# coding: utf-8

class Aggregator
  attr_reader :current_time

  def initialize(current_time)
    @current_time = current_time
  end

  # 日別、月別集計データ更新
  def aggregate
    aggregate_daily_solars
    aggregate_daily_summaries
    aggregate_monthly_solars
    aggregate_monthly_summaries
  end

  private
    def aggregate_daily_solars
      date_query = {date: current_time.strftime('%Y%m%d') }
      daily_solar_data = Solar.collection.aggregate([
        { :$match => date_query.merge({site_status: '正常'}) },
        { :$group => { _id: {date: '$date', facility_id: "$facility_id" },
                       facility_id: { :$last => "$facility_id" },
                       total_kwh: { :$max => "$today_kwh" },
                       avg_kw: { :$avg => "$now_kw"},
                       avg_sun: { :$avg => "$sun_value"},
                       avg_temp: { :$avg => "$temp_value"}
                     } 
        }
      ])

      daily_solar_data.each do |data|
        daily_solar = DailySolar.find_or_initialize_by(_id: data[:_id])
        daily_solar.attributes = data.to_hash
        if last_solar_in_date = Solar.where(date_query.merge(facility_id: data[:facility_id])).order_by(date_time: 'desc').first
          daily_solar.site_status = last_solar_in_date.site_status
          daily_solar.sales = last_solar_in_date.sales
        end
        daily_solar.date_time = current_time
        daily_solar.save
      end
    end

    def aggregate_daily_summaries
      date_query = { date: current_time.strftime('%Y%m%d') }
      daily_summary_data = Summary.collection.aggregate([
        { :$match => date_query.merge({site_status: '正常'}) },
        { :$group => { _id: {date: '$date'},
                       total_kwh: { :$max => "$today_kwh" },
                       avg_kw: { :$avg => "$now_kw"}
                     } 
        }
      ])

      daily_summary_data.each do |data|
        daily_summary = DailySummary.find_or_initialize_by(_id: data[:_id])
        daily_summary.attributes = data.to_hash
        if last_summary_in_date = Summary.where(date_query).order_by(date_time: 'desc').first
          daily_summary.site_status = last_summary_in_date.site_status
          daily_summary.sales = last_summary_in_date.sales
        end
        daily_summary.date_time = current_time
        daily_summary.save
      end
    end

    def aggregate_monthly_solars
      # TODO
    end

    def aggregate_monthly_summaries
      # TODO
    end
end