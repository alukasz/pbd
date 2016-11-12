columns = [
  :title,
  :description,
  :slides,
  :public,
  :highlighted,
  :start_time,
  :topic_id,
  :room_id,
  :schedule_day_id
]

values = []
schedule_days = ScheduleDay.count
TALKS.times do |i|
  values << [
    Faker::Educator.course,
    Faker::Hipster.paragraph,
    normal_chance(Faker::Internet.url),
    high_chance,
    low_chance,
    Faker::Time.between(1.year.ago, Time.now),
    id_for(TOPICS),
    id_for(ROOMS),
    id_for(schedule_days)
  ]
  if i % BATCH_SIZE == 0
    Talk.import columns, values, validates: false
    values = []
  end
end
Talk.import columns, values, validates: false
completed(TALKS)
