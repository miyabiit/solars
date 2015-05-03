# -*- coding: utf-8 -*-
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

require 'nokogiri'

Capybara.current_driver = :selenium
Capybara.app_host = 'https://services32.energymntr.com/megasolar/COK0132285/widemonitor/index.php'
Capybara.default_wait_time = 5 

module Crawler
	class Megasolar
		include Capybara::DSL
		attr_accessor :solar_page, :solars, :summary

		def initialize
			@summary = []
			@solars = []
		end

		def login
			visit('')
			fill_in "idtext",
				:with => 'COK0132285'
			fill_in "pwtext",
				:with => 'bfifzLxMg3qWrmt'
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
	end
end

crawler = Crawler::Megasolar.new
crawler.get_data
crawler.parse
# show 
p crawler.summary[0,crawler.summary.size - 1].join(",")
crawler.solars.each do |s|
	p s[0, s.size - 2].join(",")
end
