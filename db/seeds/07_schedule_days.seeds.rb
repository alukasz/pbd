columns = [
  :public,
  :day,
  :conference_id
]

values = []
Conference.pluck(:id, :start_date).each do |conference|
  number(MIN_SCHEDULE_DAYS, MAX_SCHEDULE_DAYS).times do |i|
    values << [
      high_chance ? true : false,
      conference[1] + i.day,
      conference[0]
    ]
    if i % BATCH_SIZE == 0
      ScheduleDay.import columns, values, validates: false
      values = []
    end
  end
end
ScheduleDay.import columns, values, validates: false
completed(ScheduleDay.count)
