# coding: utf-8

class SummaryAggregator 
  attr_reader :current_time

  def initialize(current_time)
    @current_time = current_time
  end

  def aggregate
    aggregate_daily_summaries
  end

  private
    def aggregate_daily_summaries
      date_query = { date: current_time.strftime('%Y%m%d') }

      # TODO: たまに前日の値が返ってくることがある？ 更新タイミングに依存している可能性が高い
      mega_summary_data = Summary.collection.aggregate([
        { :$match => date_query.merge({site_status: '正常'}) },
        { :$group => { _id: {date: '$date'},
                       total_kwh: { :$max => "$today_kwh" }
                     } 
        }
      ])

      eco_megane_facility_ids = EcoMeganeFacility.pluck(:_id)
      eco_megane_summary_data = DailySolar.collection.aggregate([
        { :$match => date_query.merge({facility_id: {:$in => eco_megane_facility_ids}}) },
        { :$group => { _id: {date: '$date'},
                       total_kwh: { :$sum => "$total_kwh" },
                       sales: { :$sum => "$sales"}
                     } 
        }
      ])

      mega_data = mega_summary_data.first
      eco_data = eco_megane_summary_data.first
      target_id = mega_data.try(:[], :_id) || eco_data.try(:[], :_id)
      if target_id
        daily_summary = DailySummary.find_or_initialize_by(_id: target_id)
        daily_summary.total_kwh = (eco_data.try(:[], 'total_kwh') || 0)
        daily_summary.sales = eco_data.try(:[], 'sales') || 0
        if last_summary_in_date = Summary.where(date_query).order_by(date_time: 'desc').first
          daily_summary.total_kwh += last_summary_in_date.today_kwh
          daily_summary.sales += last_summary_in_date.sales
        end
        daily_summary.date_time = current_time
        daily_summary.save
      end
    end
end
