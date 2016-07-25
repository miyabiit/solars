# coding: utf-8

class EcoMeganeAggregator
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
      daily_solar_data = EcoMeganeHourData.collection.aggregate([
        { :$match => date_query },
        { :$group => { _id: {date: '$date', facility_id: "$facility_id" },
                       facility_id: { :$last => "$facility_id" },
                       total_kwh: { :$sum => "$kwh" },
                       sales: { :$sum => "$sales" }
                     } 
        }
      ])

      daily_solar_data.each do |data|
        daily_solar = DailySolar.find_or_initialize_by(_id: data[:_id])
        daily_solar.attributes = data.to_hash
        daily_solar.date_time = current_time
        daily_solar.save
      end
    end
end
