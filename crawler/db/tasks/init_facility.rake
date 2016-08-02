desc "initialize facility"
task init_facility: [:connect_db] do
  Facility.all.each do |facility|
    facility.disp_name = facility.name unless facility.disp_name
    facility.save
  end
end
