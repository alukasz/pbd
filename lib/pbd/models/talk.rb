class Talk < ActiveRecord::Base
  belongs_to :schedule_day
  belongs_to :room
  belongs_to :topic
  
  has_and_belongs_to_many :users

  has_many :reviews
end
