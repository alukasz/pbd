class Conference < ActiveRecord::Base
  has_many :registration_types
  has_many :registrations

  has_many :sponsorships
  has_many :sponsors, through: :sponsors

  has_many :schedule_days
  has_many :talks, through: :schedule_days

  has_and_belongs_to_many :topics
end
