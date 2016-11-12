columns = [
  :name,
  :description,
  :requires_ticket,
  :amount,
  :currency,
  :conference_id,
]

types = [
  "owner",
  "manager",
  "visitor",
  "presenter",
  "reported",
  "tv_crew",
  "reviewer",
  "guest",
  "listener"
]

values = []
CONFERENCES.times do |i|
  values = values + types.map do |type|
    listener = type == 'listener' || type == 'visitor'
    [
      type,
      high_chance(Faker::Hipster.sentence),
      listener,
      listener ? number(1_000, 200_000) : nil,
      listener ? currency : nil,
      i + 1
    ]
  end
end
RegistrationType.import columns, values, validates: false
completed(values.size)
