require_relative "support"
extend Support

columns = [
  :number,
  :size,
  :venue_id
]

values = []
ROOMS.times do |i|
  coords = high_chance
  values << [
    Faker::Address.building_number,
    number(50, 5000),
    id_for(VENUES)
  ]
  if i % BATCH_SIZE == 0
    Room.import columns, values, validates: false
    values = []
  end
end
Room.import columns, values, validates: false
completed(ROOMS)
