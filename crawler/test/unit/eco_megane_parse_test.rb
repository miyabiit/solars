require_relative "../test_helper"

require_relative "../../app/eco_megane_parse"

class EcoMeganeParseTest < Minitest::Test
  def setup
    Summary.delete_all
    Solar.delete_all
    EcoMeganeHourData.delete_all
    Facility.delete_all
    Equipment.delete_all
    DailySolar.delete_all
    DailySummary.delete_all
  end

  def teardown
  end

  def test_saved_data
    csv_data = File.read('test/data/csv/ecomegane.csv')
    crawler = ::Crawler::EcoMegane.new
    crawler.create_hour_data_from_csv(csv_data.encode("UTF-8", "Shift_JIS"), false)
    EcoMeganeAggregator.new(Time.parse('2016-07-24 12:00:00')).aggregate
    SummaryAggregator.new(Time.parse('2016-07-24 12:00:00')).aggregate

    daily_data = DailySolar.where(date: '20160724').first

    assert_equal '茨城県（エコめがね）', daily_data.facility.name
    assert_equal 1525, daily_data.total_kwh
    assert_equal (1525.1039 * 36).to_i, daily_data.sales
    assert_equal '20160724', daily_data.date

    summary_data = DailySummary.where(date: '20160724').first
    assert_equal 1525, summary_data.total_kwh
    assert_equal (1525.1039 * 36).to_i, summary_data.sales
    assert_equal '20160724', summary_data.date
  end
end
