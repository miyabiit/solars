# -*- coding: utf-8 -*-
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

require 'mongo'
require 'nokogiri'

require 'active_support'
require 'active_support/core_ext'

AppRoute ||= Pathname.new(File.expand_path(File.dirname(__FILE__) + "/.."))

def load_app_libraries(load_paths)
  load_paths.each do |load_path|
    Dir[AppRoute.join(load_path).to_s + '/*.rb'].each do |path|
      require path
    end
  end
end
load_app_libraries ['app/models', 'app/lib']

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = :poltergeist
  config.javascript_driver = :poltergeist

  #todo `https` is failed then changed 'http'
  #config.app_host = 'https://services32.energymntr.com/megasolar/COK0132285/login/'
  config.app_host = 'http://services32.energymntr.com/megasolar/COK0132285/login/'

  config.default_max_wait_time = 5 
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
      current_time = Time.now
      total_sales = 0

      @solars.each do |s|
        s = s.map{|v| v == '--' ? nil : v}

        facility = find_or_create_facility(s[0])

        solar = Solar.new({
          facility:      facility,
          name:          s[0],
          today_title:   s[1],
          today_kwh:     s[2].presence,
          today_unit:    s[3],
          now_title:     s[4],
          now_kw:        s[5].presence,
          now_unit:      s[6],
          sun_title:     s[7],
          sun_value:     s[8].presence,
          sun_unit:      s[9],
          temp_title:    s[10],
          temp_value:    s[11].presence,
          temp_unit:     s[12],
          site_title:    s[13],
          site_status:   s[14],
          date_time:     current_time
        })
        solar.set_sales
        total_sales += solar.sales || 0
        solar.save
      end

      converted_summary = summary.map{|v| v == '--' ? nil : v}
      Summary.create({
        today_title:    converted_summary[0],
        today_kwh:      converted_summary[1].presence,
        today_unit:     converted_summary[2],
        now_title:      converted_summary[3],
        now_kw:         converted_summary[4].presence,
        now_unit:       converted_summary[5],
        total_title:    converted_summary[6],
        total_kwh:      converted_summary[7].presence,
        total_unit:     converted_summary[8],
        site_title:     converted_summary[9],
        site_status:    converted_summary[10],
        update_title:   converted_summary[11],
        update_date:    converted_summary[12],
        update_time:    converted_summary[13],
        sales:          total_sales,
        date_time:      current_time
      })

    end

    private

      def find_or_create_facility(name)
        Facility.where(name: name).find_one_and_update(
          { :$setOnInsert => { unit_price: 36 } },
          return_document: :after,
          upsert: true
        )
      end

      def convert_double_minus_to_nil(values)
        values.map{|v| v == '--' ? nil : v}
      end
  end
end

if $0 === __FILE__
  AppEnv = ENV['APP_ENV'].presence || 'development'
  Mongoid.load!(AppRoute.join('config', 'mongoid.yml'), AppEnv)

  crawler = Crawler::Megasolar.new
  crawler.get_data
  crawler.parse
  crawler.save
  # show 
  p crawler.summary[0,crawler.summary.size - 1].join(",")
  crawler.solars.each do |s|
    p s[0, s.size - 2].join(",")
  end

  aggregator = Aggregator.new(Time.now)
  aggregator.aggregate
end