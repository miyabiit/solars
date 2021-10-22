# -*- coding: utf-8 -*-

require 'selenium-webdriver'

require 'mongo'
require 'nokogiri'
require 'moji'
require 'csv'

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

module Crawler
  class EcoMegane

    def initialize
      @cookie_str = nil
    end

    def login
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      driver = Selenium::WebDriver.for :chrome, options: options
      begin
        driver.manage.timeouts.implicit_wait = 5
        driver.get 'https://partner.eco-megane.jp/i/index.php'
        company_id_elem = driver.find_element(:id, 'company_id')
        login_id_elem = driver.find_element(:id, 'login_id')
        password_elem = driver.find_element(:id, 'password')
        submit_elem = driver.find_element(:css, '.submit')

        company_id_elem.send_keys 'B2214'
        login_id_elem.send_keys 'megane2214'
        password_elem.send_keys '64ma6f'

        submit_elem.click

        @cookie_str = driver.manage.all_cookies.each_with_object([]) { |cookie, array| array.push("#{cookie[:name]}=#{cookie[:value]}") }.join('; ')
      ensure
        driver.quit
      end

    end

    def get_csv(target_date = Date.today, is_update_all = false)
      response = post('https://partner.eco-megane.jp/i/index.php', {
        'outputKind' => 0,
        'dayflg' => 0,
        'measureGenerateAmountFrom' => target_date.strftime('%Y/%m/%d'),
        'measureGenerateAmountTo' => target_date.strftime('%Y/%m/%d'),
        'fnc' => 'bmypagetop',
        'act' => 'csvDownloadMeasureGenerateAmount',
      })
      if response.code.to_i == 200
        create_hour_data_from_csv(response.body.encode("UTF-8", "Shift_JIS"), is_update_all)
      end
    end

    def create_hour_data_from_csv(text, is_update_all)
      target_time = Time.now
      csv = CSV.new(text, headers: true)
      table = csv.read
      # han_to_zen: MongoDBで使われる特殊記号('.' '$')がキーに含まれても問題ないよう全角文字変換
      table.each do |row|
        hash = Hash[*row.flat_map{|k, v| [Moji.han_to_zen(k.strip), v]}]
        data = EcoMeganeHourData.new(raw_data: hash, date_time: target_time)
        data.set_values
        next if data.equipment_id.blank? || data.raw_data['都道府県'].blank?
        facility, equipment = find_or_create_facility_and_equipment(data.equipment_id, data.raw_data['設備名（ＭＥＭＯ）'], data.raw_data['都道府県'])
        data.facility = facility
        data.equipment = equipment
        if !EcoMeganeHourData.where(date_time: data.date_time, equipment_id: data.equipment_id).exists?
          data.save
        elsif is_update_all
          EcoMeganeHourData.delete_all(date_time: data.date_time, equipment_id: data.equipment_id)
          data.save
        end
        #puts data.inspect
      end
    end

    private

      def post(url, params)
        unless @cookie_str
          raise 'Failed to login to the target site'
        end
        url = URI.parse(url)

        req = Net::HTTP::Post.new(url.path, {'Cookie' => @cookie_str})
        req.set_form_data(params)
        http = Net::HTTP.new(url.host, url.port)
        #http.set_debug_output $stderr
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        http.start do |h|
          response, _ = h.request(req)
          return response
        end
      end

      def find_or_create_facility_and_equipment(equipment_id, equipment_name, equipment_prefecture)
        facility = EcoMeganeFacility.where(prefecture: equipment_prefecture).find_one_and_update(
          { :$setOnInsert => { name: "#{equipment_prefecture}（エコめがね）" } },
          return_document: :after,
          upsert: true
        )

        equipment = Equipment.where(_id: equipment_id, self_id: equipment_id).find_one_and_update(
          {
            :$setOnInsert => { unit_price: 36, facility_id: facility.try(:id) },
            :$set => { name: equipment_name }
          },
          return_document: :after,
          upsert: true
        )
        [facility, equipment]
      end
  end
end

if $0 === __FILE__
  AppEnv = ENV['APP_ENV'].presence || 'development'
  Mongoid.load!(AppRoute.join('config', 'mongoid.yml'), AppEnv)

  is_yesterday_target = (ARGV[0] == 'yesterday')
  target_time = (is_yesterday_target ? Date.yesterday.to_time.end_of_day : Time.now)
  target_date = target_time.to_date

  crawler = Crawler::EcoMegane.new
  crawler.login
  crawler.get_csv(target_date, is_yesterday_target)

  EcoMeganeAggregator.new(target_time).aggregate
  SummaryAggregator.new(target_time).aggregate
end
