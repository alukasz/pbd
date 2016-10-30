class User < ActiveRecord::Base
  has_many :registrations
  has_many :tickets, through: :registrations

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :topics
  has_and_belongs_to_many :talks
end
