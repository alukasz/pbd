columns = [
  :title,
  :description,
  :logo,
  :start_date,
  :end_date,
  :registration_start_date,
  :registration_end_date,
  :ticket_limit
]

values = []
CONFERENCES.times do |i|
  start_date = Faker::Date.between(3.years.ago, 1.years.from_now)
  registration_start_date = high_chance(start_date - number(20, 50))

  values << [
    Faker::Company.catch_phrase,
    Faker::Hipster.paragraph,
    high_chance("images/conferences/conference-#{i}jpg"),
    start_date,
    start_date + number(1, 15),
    registration_start_date,
    registration_start_date ? registration_start_date + number(1, 20) : nil,
    very_high_chance(number(50, 200), number(200, 10_000))
  ]
  if i % BATCH_SIZE == 0
    Conference.import columns, values, validates: false
    values = []
  end
end
Conference.import columns, values, validates: false
completed(CONFERENCES)
