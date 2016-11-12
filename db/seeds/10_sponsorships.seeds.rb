columns = [
  :amount,
  :currency,
  :sponsor_id,
  :conference_id
]

values = []
SPONSORSHIPS.times do |i|
  values << [
    number(10_000, 100_000_000),
    currency,
    id_for(SPONSORS),
    id_for(CONFERENCES)
  ]
  if i % BATCH_SIZE == 0
    Sponsorship.import columns, values, validates: false
    values = []
  end
end
Sponsorship.import columns, values, validates: false
completed(SPONSORSHIPS)
