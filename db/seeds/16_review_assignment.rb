columns = [
  :deadline,
  :user_id,
  :talk_id,
  :review_id
]

values = []
talks = []
REVIEW_ASSIGNMETS.times do |i|
  talks << id_for(TALKS)
end

talks.uniq.each do |i|
  [3, 5, 7].sample.times do |t|
    values << [
      Faker::Date.between(3.years.ago, 1.years.from_now),
      id_for(USERS),
      i,
      high_chance(id_for(REVIEWS))
    ]
    if i % BATCH_SIZE == 0
      ReviewAssignment.import columns, values, validates: false
      values = []
    end
  end
end
ReviewAssignment.import columns, values, validates: false
completed(REVIEW_ASSIGNMETS)
