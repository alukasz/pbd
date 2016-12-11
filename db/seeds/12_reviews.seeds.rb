columns = [
  :title,
  :content,
  :talk_id,
  :user_id,
  :approved,
  :created_at,
  :updated_at
]

values = []
REVIEWS.times do |i|
  date = Faker::Date.between(3.years.ago, 1.years.from_now)
  values << [
    Faker::Hacker.say_something_smart,
    Faker::Hipster.paragraph,
    id_for(TALKS),
    id_for(USERS),
    normal_chance(true, false),
    date,
    date
  ]
  if i % BATCH_SIZE == 0
    Review.import columns, values, validates: false
    values = []
  end
end
Review.import columns, values, validates: false
completed(REVIEWS)
