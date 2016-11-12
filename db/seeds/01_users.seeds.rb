require_relative "support"
extend Support

columns = [
  :firstname,
  :lastname,
  :email,
  :password,
  :confirmation_token,
  :confirmed_at,
  :remember_at,
  :bio,
  :nickname,
  :affiliation,
  :phone,
  :avatar,
  :email_public,
  :phone_public
]

values = []
USERS.times do |i|
  values << [
    Faker::Name.first_name,
    Faker::Name.last_name,
    Faker::Internet.email + i.to_s,
    Faker::Lorem.characters(30),
    Faker::Lorem.characters(30),
    Faker::Date.between(3.years.ago, Date.today),
    normal_chance(Faker::Date.between(1.month.ago, Date.today)),
    Faker::Hipster.paragraph,
    Faker::Internet.user_name,
    Faker::Company.name,
    Faker::PhoneNumber.phone_number,
    "images/avatar/user-#{i}.jpg",
    high_chance,
    low_chance
  ]
  if i % BATCH_SIZE == 0
    User.import columns, values, validates: false
    values = []
  end
end
User.import columns, values, validates: false
completed(USERS)
