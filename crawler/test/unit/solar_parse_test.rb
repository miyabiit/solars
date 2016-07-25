require_relative "../test_helper"

require_relative "../../app/solar_parse"

class SolarParseTest < Minitest::Test
  def setup
    Summary.delete_all
    Solar.delete_all
    EcoMeganeHourData.delete_all
    Facility.delete_all
    DailySolar.delete_all
    DailySummary.delete_all
  end

  def teardown
  end

  def test_saved_data
    html = File.read('test/data/html/solars.html')
    html.gsub!(/2016\/07\/05/, Date.today.strftime('%Y/%m/%d')) # change update_date
    crawler = ::Crawler::Megasolar.new
    crawler.solar_page = Nokogiri::HTML.parse(html)
    crawler.parse
    crawler.save

    # test summary ==
    summary = Summary.first

    assert_equal '本日の合計発電電力量', summary.today_title
    assert_equal 41460, summary.today_kwh
    assert_equal 'kWh', summary.today_unit

    assert_equal '現在の合計発電電力', summary.now_title
    assert_equal 1426.5, summary.now_kw
    assert_equal 'kW', summary.now_unit

    assert_equal '積算発電電力量', summary.total_title
    assert_equal 19841768, summary.total_kwh
    assert_equal 'kWh', summary.total_unit

    assert_equal 'サイト状況', summary.site_title
    assert_equal '正常', summary.site_status

    assert_equal '表示更新日時', summary.update_title
    assert_equal Date.today.strftime('%Y/%m/%d'), summary.update_date
    assert_equal '17:33', summary.update_time

    assert_equal  1492596, summary.sales

    # TODO: 日付固定
    assert_equal Date.today.strftime('%Y%m%d'), summary.date
    assert (summary.date_time > Time.now.ago(10.minutes) && summary.date_time < Time.now)

    # test solars ==
    solar = Solar.where(name: '宝塚市境野（500kW）').first

    assert_equal '本日の発電電力量', solar.today_title
    assert_equal 1912, solar.today_kwh
    assert_equal 'kWh', solar.today_unit

    assert_equal '現在の発電電力', solar.now_title
    assert_equal 62.1, solar.now_kw
    assert_equal 'kW', solar.now_unit

    assert_equal '日射強度', solar.sun_title
    assert_equal 0.14, solar.sun_value
    assert_equal 'kw/㎡', solar.sun_unit

    assert_equal '外気温度', solar.temp_title
    assert_equal 30.8, solar.temp_value
    assert_equal '℃', solar.temp_unit

    assert_equal 'サイト状況', solar.site_title
    assert_equal '正常', solar.site_status

    assert_equal 36 * 1912, solar.sales

    # TODO: 日付固定
    assert_equal Date.today.strftime('%Y%m%d'), solar.date
    assert (solar.date_time > Time.now.ago(10.minutes) && solar.date_time < Time.now)


  end
end
