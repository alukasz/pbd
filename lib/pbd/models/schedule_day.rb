class ScheduleDay < ActiveRecord::Base
  belongs_to :conference
  has_many :talks
end
