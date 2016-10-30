require "faker"
require "as-duration"
require "activerecord-import/base"
require_relative "../lib/pbd"

ActiveRecord::Import.require_adapter("mysql2")
ActiveRecord::Base.logger = nil

def number_between(from, to)
  rand(from..to)
end

CONFERENCES = 555
USERS = CONFERENCES * number_between(40, 60) + number_between(1, 100)
ROLES = 5
VENUES = CONFERENCES / number_between(10, 25) + number_between(1, 20)
ROOMS = VENUES * number_between(2, 6) + number_between(2, 6)
SPONSORS = CONFERENCES * number_between(2, 4) + number_between(1, 10)
SPONSORSHIPS = number_between((SPONSORS + CONFERENCES) * 2, (SPONSORS + CONFERENCES) * 3)
MAX_SCHEDULES = 5
MIN_TALKS_DAILY = 1
MAX_TALKS_DAILY = 8
TOPICS = number_between(30, 40)
REVIEWS = number_between(CONFERENCES * 42, CONFERENCES * 84)

# helper methods
def high_chance(expression = true, other = nil)
  rand < 0.8 ? expression : other
end

def low_chance(expression = true, other = nil)
  rand < 0.2 ? expression : other
end

def normal_chance(expression = true, other = nil)
  rand < 0.5 ? expression : other
end

def very_high_chance(expression = true, other = nil)
  rand < 0.95 ? expression : other
end

def id(number)
  number_between(1, number)
end

def currency
  ['PLN', 'EUR', 'USD'].sample
end

def registration_types
  ['Presenter', 'Listener', 'Guard', 'Volunteer']
end

users = []
USERS.times do |i|
  users << User.new(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email + i.to_s,
    password: Faker::Lorem.characters(60),
    confirmation_token: Faker::Lorem.characters(60),
    confirmed_at: Faker::Date.between(3.years.ago, Date.today),
    bio: Faker::Hipster.paragraph,
    nickname: Faker::Internet.user_name,
    affiliation: Faker::Company.name,
    phone: Faker::PhoneNumber.phone_number,
    avatar: "images/avatar/user-#{i}.jpg",
    email_public: high_chance,
    phone_public: low_chance
  )
end
User.import users, validates: false
puts "Inserted #{users.size} Users."

roles = []
ROLES.times do |i|
  roles << Role.new(
    name: Faker::Superhero.power,
    description: Faker::Hipster.sentence
  )
end
Role.import roles, validates: false
puts "Inserted #{roles.size} Roles."

conferences = []
CONFERENCES.times do |i|
  start_date = Faker::Date.between(3.years.ago, 1.years.from_now)
  registration_start_date = high_chance(start_date - number_between(20, 50))

  conferences << Conference.new(
    title: Faker::Company.catch_phrase,
    description: Faker::Hipster.paragraph,
    logo: high_chance("images/conferences/conference-#{i}jpg"),
    start_date: start_date,
    end_date: start_date + number_between(1, 15),
    registration_start_date: registration_start_date,
    registration_end_date: registration_start_date ? registration_start_date + number_between(1, 20) : nil,
    ticket_limit: very_high_chance(number_between(50, 200), number_between(200, 10_000))
  )
end
Conference.import conferences, validates: false
puts "Inserted #{conferences.size} Conferences."

# FIX find appropriate name for topic
topics = []
TOPICS.times do |i|
  topics << Topic.new(
    name: Faker::Superhero.power
  )
end
Topic.import topics, validates: false
puts "Inserted #{topics.size} Topics."

venues = []
VENUES.times do |i|
  coords = high_chance

  venues << Venue.new(
    name: Faker::Lorem.word,
    website: high_chance(Faker::Internet.url),
    description: high_chance(Faker::Hipster.paragraph),
    country: Faker::Address.country_code,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    postal_code: Faker::Address.postcode,
    latitude: coords ? Faker::Address.latitude : nil,
    longitude: coords ? Faker::Address.longitude : nil,
    photo: high_chance("images/avatar/venue-#{i}.jpg")
  )
end
Venue.import venues, validates: false
puts "Inserted #{venues.size} Venues."

rooms = []
ROOMS.times do |i|
  rooms << Room.new(
    number: Faker::Address.building_number,
    size: number_between(50, 5000),
    venue_id: id(VENUES)
  )
end
Room.import rooms, validates: false
puts "Inserted #{rooms.size} Rooms."

sponsors = []
SPONSORS.times do |i|
  sponsors << Sponsor.new(
    name: Faker::Company.name,
    description: high_chance(Faker::Hipster.paragraph),
    website: high_chance(Faker::Internet.domain_name),
    logo: high_chance("images/sponsors/sponsor-#{i}.jpg")
  )
end
Sponsor.import sponsors, validates: false
puts "Inserted #{sponsors.size} Sponsors."

# FIX sponsor can support the same conference multiple times
sponsorships = []
SPONSORSHIPS.times do |i|
  sponsorships << Sponsorship.new(
    amount: number_between(10_000, 100_000_000),
    currency: currency,
    sponsor_id: id(SPONSORS),
    conference_id: id(CONFERENCES)
  )
end
Sponsorship.import sponsorships, validates: false
puts "Inserted #{sponsorships.size} Sponsorships."

# schedule days for conference and talks for schedule day
schedule_days = []
talks = []
Conference.all.each do |conference|
  number_between(1, MAX_SCHEDULES).times do |day|
    schedule_day = ScheduleDay.new(
      public: high_chance ? true : false,
      day: conference.start_date + day,
      conference_id: conference.id
    )
    schedule_days << schedule_day

    number_between(MIN_TALKS_DAILY, MAX_TALKS_DAILY).times do
      talks << Talk.new(
        title: Faker::Educator.course,
        description: Faker::Hipster.paragraph,
        slides: normal_chance(Faker::Internet.url),
        public: high_chance,
        highlighted: low_chance,
        start_time: Faker::Time.between(schedule_day.day, schedule_day.day + 23.hours),
        topic_id: id(TOPICS),
        room_id: id(ROOMS),
        schedule_day_id: schedule_day.id
      )
    end
  end
end
ScheduleDay.import schedule_days, validates: false
Talk.import talks, validates: false
puts "Inserted #{schedule_days.size} ScheduleDays."
puts "Inserted #{talks.size} Talks."

TALKS = Talk.count
reviews = []
REVIEWS.times do |i|
  reviews << Review.new(
    title: Faker::Hacker.say_something_smart,
    content: Faker::Hipster.paragraph,
    talk_id: id(TALKS),
    user_id: id(USERS)
  )
end
Review.import reviews, validates: false
puts "Inserted #{reviews.size} Reviews."

registration_types_arr = []
CONFERENCES.times do |i|
  registration_types.each do |type|
    listener = type == 'Listener'
    registration_types_arr << RegistrationType.new(
      name: type,
      description: normal_chance(Faker::Hipster.sentence),
      requires_ticket: listener,
      amount: listener ? number_between(1_000, 200_000) : nil,
      currency: listener ? currency : nil,
      conference_id: i + 1
    )
  end
end
RegistrationType.import registration_types_arr, validates: false
puts "Inserted #{registration_types_arr.size} RegistrationTypes."

# FIX price of ticket
# FIX registered_at does not match conference registration times
# FIX ticket doest not match
tickets = []
registrations = []
Conference.all.each do |conference|
  (conference.ticket_limit / 3).round.times do |i|
    if conference.registration_start_date
      tickets << Ticket.new(
        created_at: Faker::Time.between(conference.registration_start_date, conference.registration_end_date),
        quantity: number_between(1, 4),
        price: number_between(1_000, 800_000),
        currency: currency,
        paid: high_chance ? true : false
      )

      registrations << Registration.new(
        registered_at: Faker::Time.between(3.years.ago, 2.years.from_now),

        conference_id: id(CONFERENCES),
        user_id: id(USERS),
        registration_type_id: id(CONFERENCES * registration_types.size),
        ticket_id: i+1
      )
    end
  end
end
Ticket.import tickets, validates: false
Registration.import registrations, validates: false
puts "Inserted #{tickets.size} Tickets."
puts "Inserted #{registrations.size} Registrations."

# seed join tables
roles_users = []
roles_users_columns = [:role_id, :user_id]
(ROLES * USERS / 3.1415).round.times do
  roles_users << [
    number_between(1, ROLES),
    number_between(1, USERS)
  ]
end
roles_users_uniq = roles_users.uniq
RoleUser.import roles_users_columns, roles_users_uniq, validate: false
puts "Inserted #{roles_users_uniq.size} RoleUser."

talks_users = []
talks_users_columns = [:talk_id, :user_id]
TALKS.times do
  n = number_between(1, TALKS)
  talks_users << [
    n,
    number_between(1, USERS)
  ]
  if low_chance # low chance that talk has multiple presenters
    number_between(1, 4).times do
      talks_users << [
        n,
        number_between(1, USERS)
      ]
    end
  end
end
talks_users_uniq = talks_users.uniq
TalkUser.import talks_users_columns, talks_users_uniq, validate: false
puts "Inserted #{talks_users_uniq.size} TalkUser."

topics_users = []
topics_users_columns = [:topic_id, :user_id]
USERS.times do |user|
  if low_chance # low chance that user is an expert on some topic
    topics_users << [
      number_between(1, TOPICS),
      user + 1
    ]
    if normal_chance # but normal chance that is expert on some other(s) topics
      number_between(1, 4).times do
        topics_users << [
          number_between(1, TOPICS),
          user + 1
        ]
      end
    end
  end
end
topics_users_uniq = topics_users.uniq
TopicUser.import topics_users_columns, topics_users_uniq, validate: false
puts "Inserted #{topics_users_uniq.size} TopicUser."

conferences_topics = []
conferences_topics_columns = [:conference_id, :topic_id]
CONFERENCES.times do |conference|
  number_between(1, (TOPICS/2).round).times do |topic|
    conferences_topics << [
      conference + 1,
      topic + 1
    ]
  end
end
conferences_topics_uniq = conferences_topics.uniq
ConferenceTopic.import conferences_topics_columns, conferences_topics_uniq, validate: false
puts "Inserted #{conferences_topics_uniq.size} ConferenceTopic."
