class Review < ActiveRecord::Base
  belongs_to :reviewer, class_name: :user
  belongs_to :talk
end
