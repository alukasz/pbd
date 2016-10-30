require "faker"
require "as-duration"
require_relative "../lib/pbd"

CONFERENCES = 1
USERS = CONFERENCES * 100
VENUES = CONFERENCES * 2
ROOMS = VENUES * 3
SPONSORS = CONFERENCES * 3
SPONSORSHIPS = (SPONSORS + CONFERENCES) * 2
#SCHEDULES = CONFERENCES * 1-5;
#TALKS = CONFERENCES * 3-10;
TOPICS = 42
REVIEWS = CONFERENCES * 20

# helper methods

def boolean(true_ratio = 0.5)
  Faker::Boolean.boolean(true_ratio)
end

def high_chance(value = true)
  boolean(0.8) ? value : nil
end

def low_chance(value = true)
  boolean(0.2) ? value : nil
end

def normal_chance(value = true)
  boolean ? value : nil
end

def id(number)
  Faker::Number.between(1, number)
end

def currency
  ['PLN', 'EUR', 'USD'].sample
end

def registration_types
  ['Presenter', 'Listener', 'Guard', 'Volunteer']
end


USERS.times do |i|
  nickname = Faker::Internet.user_name + i.to_s

  User.create(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(60),
    confirmation_token: Faker::Lorem.characters(60),
    confirmed_at: Faker::Date.between(3.years.ago, Date.today),
    bio: Faker::Hipster.paragraphs.join(" "),
    nickname: nickname,
    affiliation: Faker::Company.name,
    phone: Faker::PhoneNumber.phone_number,
    avatar: "images/avatar/#{nickname}.jpg",
    email_public: high_chance,
    phone_public: low_chance
  )
end

CONFERENCES.times do |i|
  nickname = Faker::Internet.user_name + i.to_s
  start_date = Faker::Date.between(3.years.ago, 2.years.from_now)
  registration = high_chance
  registration_start_date = start_date - Faker::Number.between(20, 50) if registration

  Conference.create(
    title: Faker::Company.catch_phrase,
    description: Faker::Hipster.paragraphs.join(" "),
    logo: high_chance("images/avatar/#{nickname}.jpg"),
    start_date: start_date,
    end_date: start_date + Faker::Number.between(1, 15),
    registration_start_date: registration ? registration_start_date : nil,
    registration_end_date: registration ? registration_start_date + Faker::Number.between(1, 20) : nil,
    ticket_limit: Faker::Number.between(100, 10000)
  )
end

# FIX find appropriate name for topic
TOPICS.times do |i|
  Topic.create(
    name: Faker::Superhero.power
  )
end

VENUES.times do |i|
  coords = high_chance

  Venue.create(
    name: Faker,
    website: high_chance(Faker::Internet.url),
    description: high_chance(Faker::Hipster.paragraphs.join(" ")),
    country: Faker::Address.country_code,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    postal_code: Faker::Address.postcode,
    latitude: coords ? Faker::Address.latitude : nil,
    longitude: coords ? Faker::Address.longitude : nil,
    photo: high_chance("images/avatar/venue-#{i}.jpg")
  )
end

ROOMS.times do |i|
  Room.create(
    number: Faker::Address.building_number,
    size: Faker::Number.between(50, 5000),
    venue_id: id(VENUES)
  )
end

SPONSORS.times do |i|
  Sponsor.create(
    name: Faker::Company.name,
    description: high_chance(Faker::Hipster.paragraphs.join(" ")),
    website: high_chance(Faker::Internet.domain_name),
    logo: high_chance("images/sponsors/sponsor-#{i}.jpg")
  )
end

# FIX sponsor can support the same conference multiple times
SPONSORSHIPS.times do |i|
  Sponsorship.create(
    amount: Faker::Number.between(1000, 1_000_000),
    currency: currency,
    sponsor_id: id(SPONSORS),
    conference_id: id(CONFERENCES)
  )
end

# schedule days for conference and talks for schedule day
Conference.all.each do |conference|
  Faker::Number.between(1, 5).times do |day|
    schedule_day = ScheduleDay.new(
      public: high_chance ? true : false,
      day: conference.start_date + day
    )
    conference.schedule_days << schedule_day

    Faker::Number.between(3,10).times do |offset|
      schedule_day.talks.create(
        title: Faker::Educator.course,
        description: Faker::Hipster.paragraphs.join(" "),
        slides: normal_chance(Faker::Internet.url),
        public: high_chance,
        highlighted: low_chance,
        start_time: Faker::Time.between(schedule_day.day, schedule_day.day + 23.hours),
        topic_id: id(TOPICS),
        room_id: id(ROOMS)
      )
    end
  end
end

TALKS = Talk.count
REVIEWS.times do |i|
  Review.create(
    title: Faker::Hacker.say_something_smart,
    content: Faker::Hipster.paragraphs.join(" "),
    talk_id: id(TALKS),
    user_id: id(USERS)
  )
end

CONFERENCES.times do |i|
  registration_types.each do |type|
    listener = type == 'Listener'
    RegistrationType.create(
      name: type,
      description: normal_chance(Faker::Lorem.paragraph),
      requires_ticket: listener,
      amount: listener ? Faker::Number.between(10000, 2_000_000) : nil,
      currency: listener ? currency : nil,
      conference_id: i + 1
    )
  end
end

# FIX price of ticket
Conference.all.each do |conference|
  (conference.ticket_limit / 3).round.times do |i|
    if conference.registration_start_date
      Ticket.create(
        created_at: Faker::Time.between(conference.registration_start_date, conference.registration_end_date),
        quantity: Faker::Number.between(1, 4),
        price: Faker::Number.between(10000, 1_000_000),
        currency: currency,
        paid: high_chance ? true : false
      )
    end
  end
end

# FIX registered_at does not match conference registration times
# FIX ticket doest not match
TICKETS = Ticket.count
TICKETS.times do |i|
  Registration.create(
    registered_at: Faker::Time.between(3.years.ago, 2.years.from_now),

    conference_id: id(CONFERENCES),
    user_id: id(USERS),
    registration_type_id: id(CONFERENCES * registration_types.size),
    ticket_id: i+1
  )
end
