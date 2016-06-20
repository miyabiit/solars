# -*- coding: utf-8 -*-
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

require 'mongo'
require 'nokogiri'

Capybara.configure do |config|
	config.run_server = false
	config.current_driver = :poltergeist
	config.javascript_driver = :poltergeist

	#todo `https` is failed then changed 'http'
	#config.app_host = 'https://services32.energymntr.com/megasolar/COK0132285/login/'
	config.app_host = 'http://services32.energymntr.com/megasolar/COK0132285/login/'

	config.default_wait_time = 5 
end

Capybara.register_driver :poltergeist do |app|
	Capybara::Poltergeist::Driver.new(
		app, {:timeout => 120, js_errors: false})
end

module Crawler
	class Megasolar
		include Capybara::DSL
		attr_accessor :solar_page, :solars, :summary

		def initialize
			@summary = []
			@solars = []
		end

		def login
			page.driver.headers = {"User-Agent" => "Mac Safari", "Accept-Language" => "ja"}
			visit('')
			fill_in "idtext", :with => 'COK0132285'
			fill_in "pwtext", :with => 'bfifzLxMg3qWrmt'
			click_link "ログイン"
		end

		def get_data
			login()
			@solar_page = Nokogiri::HTML.parse(page.body)
		end

		def parse
			@summary = []
			@solars = []
			@solar_page.xpath("//p | //div[@class='totalTitle' or @class='totalValue' or @class='totalUnit' or @class='totalLabel']").each do |node|
				@summary.push(node.text.strip)
			end
			temp = []
			@solar_page.xpath("//div[@class='title' or @class='value' or @class='unit' or @class='label']").each do |node|
				temp.push(node.text.strip)
			end
			while temp.size > 0 do
				@solars.push(temp.slice!(0,17))
			end
		end

# sample 
#  1                  2     3  4                    5    6   7              8       9   10         11   12           13
# "現在の合計発電電力,317.8,kW,本日の合計発電電力量,9011,kWh,積算発電電力量,4498866,kWh,サイト状況,正常,表示更新日時,2015/05/09,15:47"
#  1                   2                3   4   5              6     7  8        9    10    11       12     13         14
# "宝塚市境野（500kW）,本日の発電電力量,661,kWh,現在の発電電力,118.3,kW,日射強度,0.27,kw/㎡,外気温度,20.0,℃,サイト状況,正常"
		def save
			db = Mongo::Client.new(['127.0.0.1:27017'], :database => 'solarsdb')
			last_summary = db[:summary].find({:status => 'last'})
			ymd = ""
			last_summary.limit(1).each do |s|
				ymd = s["date_time"]
			end
			if ymd && ymd[0..7] != Date.today.strftime("%Y%m%d")
				db[:summary].find({:status => 'last'}).update_many({'$set' => {:status => 'day'}})
			else
				db[:summary].find({:status => 'last'}).update_many({'$set' => {:status => 'done'}})
			end
			db[:summary].insert_one({
						'now_title' => summary[0],
						'now_kw'    => summary[1],
				 		'now_unit'  => summary[2],
				 		'today_title' => summary[3],
				 		'today_kwh'   => summary[4],
				 		'today_unit'  => summary[5],
				 		'total_title' => summary[6],
				 		'total_kwh'   => summary[7],
				 		'total_unit'  => summary[8],
				 		'site_title'  => summary[9],
				 		'site_status' => summary[10],
				 		'update_title' => summary[11],
				 		'update_date'  => summary[12],
						"status"	=> "last",
						"date_time" => DateTime.now.strftime("%Y%m%d%H%M")
			})
			last_solars = db[:solars].find(:status => 'last')
			ymd = ""
			last_solars.limit(1).each do |s|
				ymd = s["date_time"]
			end
			if  ymd && ymd[0..7] != Date.today.strftime("%Y%m%d") 
				last_solars.update_many("$set" => {:status => 'day'})
			else
				last_solars.update_many("$set" => {:status => 'done'})
			end
			@solars.each do |s|
				db[:solars].insert_one({
					"name"	=> s[0],
					"today_title"	=> s[1],
					"today_kwh"		=> s[2],
					"today_unit"	=> s[3],
					"now_title"		=> s[4],
					"now_kw"			=> s[5],
					"now_unit"		=> s[6],
					"sun_title"		=> s[7],
					"sun_value"		=> s[8],
					"sun_unit"		=> s[9],
					"temp_title"	=> s[10],
					"temp_value"	=> s[11],
					"temp_unit"		=> s[12],
					"site_title"	=> s[13],
					"site_status" => s[14],
					"status"	=> "last",
					"date_time" => DateTime.now.strftime('%Y%m%d%H%M')
				})
			end
		end
	end
end

if $0 === __FILE__
	crawler = Crawler::Megasolar.new
	crawler.get_data
	crawler.parse
	crawler.save
	# show 
	p crawler.summary[0,crawler.summary.size - 1].join(",")
	crawler.solars.each do |s|
		p s[0, s.size - 2].join(",")
	end
end
