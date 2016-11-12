columns = [
  :created_at,
  :quantity,
  :price,
  :currency,
  :paid,
  :registration_id
]

values = []
registration_types = RegistrationType.count
REGISTRATIONS.times do |i|
  if very_high_chance
    values << [
       Faker::Time.between(2.years.ago, Time.now),
       number(1, 4),
       number(1_000, 800_000),
       currency,
       high_chance ? true : false,
       i + 1
    ]
    if i % BATCH_SIZE == 0
      Ticket.import columns, values, validates: false
      values = []
    end
  end
end
Ticket.import columns, values, validates: false
completed(REGISTRATIONS)
