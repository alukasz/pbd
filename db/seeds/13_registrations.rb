columns = [
  :registered_at,
  :conference_id,
  :user_id,
  :registration_type_id
]

values = []
registration_types = RegistrationType.count
REGISTRATIONS.times do |i|
  values << [
    Faker::Time.between(3.years.ago, 2.years.from_now),
    id_for(CONFERENCES),
    id_for(USERS),
    id_for(registration_types)
  ]
  if i % BATCH_SIZE == 0
    Registration.import columns, values, validates: false
    values = []
  end
end
Registration.import columns, values, validates: false
completed(REGISTRATIONS)
