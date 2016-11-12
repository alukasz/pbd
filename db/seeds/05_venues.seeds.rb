columns = [
  :name,
  :website,
  :description,
  :country,
  :city,
  :street,
  :postal_code,
  :latitude,
  :longitude,
  :photo
]

values = []
VENUES.times do |i|
  coords = high_chance
  values << [
    Faker::Lorem.word,
    high_chance(Faker::Internet.url),
    high_chance(Faker::Hipster.paragraph),
    Faker::Address.country_code,
    Faker::Address.city,
    Faker::Address.street_name,
    Faker::Address.postcode,
    coords ? Faker::Address.latitude : nil,
    coords ? Faker::Address.longitude : nil,
    high_chance("images/avatar/venue-#{i}.jpg")
  ]
  if i % BATCH_SIZE == 0
    Venue.import columns, values, validates: false
    values = []
  end
end
Venue.import columns, values, validates: false
completed(VENUES)
