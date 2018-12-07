require_relative "../test_helper"

require_relative "../../app/eco_megane_parse"
require_relative "../../app/solar_parse"

class SummaryAggregatorTest < Minitest::Test
  def setup
    Summary.delete_all
    Solar.delete_all
    EcoMeganeHourData.delete_all
    Facility.delete_all
    Equipment.delete_all
    DailySolar.delete_all
    DailySummary.delete_all
  end

  def test_aggregate
    target_time = Time.parse('2016-07-24 12:00:00')

    csv_data = File.read('test/data/csv/ecomegane.csv')
    crawler = ::Crawler::EcoMegane.new
    crawler.create_hour_data_from_csv(csv_data.encode("UTF-8", "Shift_JIS"), false)
    EcoMeganeAggregator.new(target_time).aggregate

    html = File.read('test/data/html/solars.html')
    html.gsub!(/2018\/12\/07/, '2016/07/24') # change update_date
    crawler = ::Crawler::Megasolar.new
    crawler.solar_page = Nokogiri::HTML.parse(html)
    crawler.parse
    crawler.save(target_time)
    MegasolarAggregator.new(target_time).aggregate

    SummaryAggregator.new(target_time).aggregate

    summary_data = DailySummary.where(date: '20160724').first

    assert_equal (1525.1039).to_i + 21941, summary_data.total_kwh.to_i
    assert_equal (1525.1039 * 36).to_i + 789876, summary_data.sales.to_i
    assert_equal '20160724', summary_data.date
  end
end
