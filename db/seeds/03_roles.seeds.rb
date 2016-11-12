require_relative "support"
extend Support

columns = [
  :name,
  :description
]

values = [
  "administrator",
  "user",
  "reviewer",
  "moderator",
  "manager",
  "creator",
  "visitor",
]
values = values.map do |name|
  [
    name,
    Faker::Lorem.sentence
  ]
end
Role.import columns, values, validates: false
completed(values.size)
