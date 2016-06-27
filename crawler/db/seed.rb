['宝塚市境野（500kW）', '岩槻区長宮物流センタ（929kW）'].each do |name|
  Facility.where(name: name).find_one_and_update(
    {:$set => {unit_price: 40}},
    upsert: true
  )
end
