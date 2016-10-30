class RegistrationType < ActiveRecord::Base
  belongs_to :conference
  has_many :registrations
end
