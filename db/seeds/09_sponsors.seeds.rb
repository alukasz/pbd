columns = [
  :name,
  :description,
  :website,
  :logo
]

values = []
SPONSORS.times do |i|
  values << [
    Faker::Company.name,
    high_chance(Faker::Hipster.paragraph),
    high_chance(Faker::Internet.domain_name),
    high_chance("images/sponsors/sponsor-#{i}.jpg")
  ]
  if i % BATCH_SIZE == 0
    Sponsor.import columns, values, validates: false
    values = []
  end
end
Sponsor.import columns, values, validates: false
completed(SPONSORS)
