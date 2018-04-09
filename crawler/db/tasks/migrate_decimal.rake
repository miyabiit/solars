desc "migrate to decimal type"
task migrate_decimal: [:connect_db] do
  DailySolar.all.each do |daily_solar|
    daily_solar.update_attributes(total_kwh: daily_solar.total_kwh, sales: daily_solar.sales)
  end
  DailySummary.all.each do |daily_summary|
    daily_summary.update_attributes(total_kwh: daily_summary.total_kwh, sales: daily_summary.sales)
  end
  MonthlySolar.all.each do |monthly_solar|
    monthly_solar.update_attributes(total_kwh: monthly_solar.total_kwh, sales: monthly_solar.sales)
  end
  MonthlySummary.all.each do |monthly_summary|
    monthly_summary.update_attributes(total_kwh: monthly_summary.total_kwh, sales: monthly_summary.sales)
  end
end
