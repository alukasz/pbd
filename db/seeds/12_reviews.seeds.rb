columns = [
  :title,
  :content,
  :talk_id,
  :user_id
]

values = []
REVIEWS.times do |i|
  values << [
    Faker::Hacker.say_something_smart,
    Faker::Hipster.paragraph,
    id_for(TALKS),
    id_for(USERS)
  ]
  if i % BATCH_SIZE == 0
    Review.import columns, values, validates: false
    values = []
  end
end
Review.import columns, values, validates: false
completed(REVIEWS)
