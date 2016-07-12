# initialize facility
['宝塚市境野（500kW）', '岩槻区長宮物流センタ（929kW）'].each do |name|
  MegasolarFacility.where(name: name).find_one_and_update(
    {:$set => {unit_price: 40}},
    upsert: true
  )
end

ecomegane_facility = EcoMeganeFacility.find_or_create_by(name: '茨城県（エコめがね）', prefecture: '茨城県')
Equipment.where(facility_id: ecomegane_facility.id, name: 'Ｋ区画').find_one_and_update(
  {:$set => {unit_price: 32}},
  upsert: true
)
