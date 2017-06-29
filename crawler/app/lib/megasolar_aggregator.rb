# coding: utf-8

class MegasolarAggregator
  attr_reader :current_time

  def initialize(current_time)
    @current_time = current_time
  end

  # 日別、月別集計データ更新
  def aggregate
    aggregate_daily_solars
  end

  private
    def aggregate_daily_solars
      date_query = {date: current_time.strftime('%Y%m%d') }
      daily_solar_data = Solar.collection.aggregate([
        { :$match => date_query },
        { :$group => { _id: {date: '$date', facility_id: "$facility_id" },
                       facility_id: { :$last => "$facility_id" },
                       total_kwh: { :$max => "$today_kwh" },
                       sales: { :$max => "$sales" }
                     } 
        }
      ])

      daily_solar_data.each do |data|
        daily_solar = DailySolar.find_or_initialize_by(_id: data[:_id])
        daily_solar.attributes = data.to_hash
        if last_solar_in_date = Solar.where(date_query.merge(facility_id: data[:facility_id])).order_by(date_time: 'desc').first
          daily_solar.site_status = last_solar_in_date.site_status
        end
        daily_solar.date_time = current_time
        daily_solar.save
      end
    end
end
