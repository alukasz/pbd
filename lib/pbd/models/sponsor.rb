class Sponsor < ActiveRecord::Base
  has_many :sponsorships
  has_many :conferences, through: :sponsorships
end
