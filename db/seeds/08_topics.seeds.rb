columns = [
  :name
]

values = []
TOPICS.times do |i|
  values << [
    Faker::Superhero.power
  ]
end
Topic.import columns, values.uniq!, validates: false
completed(values.size)
