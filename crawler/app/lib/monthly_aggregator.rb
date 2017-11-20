# coding: utf-8

class MonthlyAggregator
  attr_reader :current_time

  def initialize(current_time)
    @current_time = current_time
  end

  def aggregate
    month = current_time.prev_month.strftime('%Y%m')
    date_query = {date: /^#{month}/ }
    monthly_solar_data_for_facilities = DailySolar.collection.aggregate([
      { :$match => date_query },
      { :$group => { _id: {facility_id: "$facility_id" },
                     facility_id: { :$last => "$facility_id" },
                     total_kwh: { :$sum => "$total_kwh" },
                     sales: { :$sum => "$sales" }
                   } 
      }
    ])

    monthly_solar_data_for_facilities.each do |data|
      monthly_solar = MonthlySolar.find_or_initialize_by(_id: data[:_id].merge({month: month}))
      monthly_solar.facility_id = data[:facility_id]
      monthly_solar.total_kwh = data[:total_kwh]
      monthly_solar.sales = data[:sales]
      monthly_solar.month = month
      monthly_solar.date_time = current_time
      if last_solar_in_month = DailySolar.where(date_query.merge(facility_id: data[:facility_id])).order_by(date_time: 'desc').first
        monthly_solar.site_status = last_solar_in_month.site_status
      end
      monthly_solar.save
    end

    monthly_summary_data = DailySummary.collection.aggregate([
      { :$match => date_query },
      { :$group => { _id: {month: month}, total_kwh: { :$sum => "$total_kwh" }, sales: { :$sum => "$sales" } } }
    ]).first

    monthly_summary = MonthlySummary.find_or_initialize_by(_id: {month: month})
    monthly_summary.attributes = monthly_summary_data.to_hash
    monthly_summary.date_time = current_time
    monthly_summary.month = month
    monthly_summary.save
  end
end
