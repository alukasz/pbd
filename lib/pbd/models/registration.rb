class Registration < ActiveRecord::Base
  belongs_to :conference
  belongs_to :user
  belongs_to :registration_type
  has_one :ticket
end
