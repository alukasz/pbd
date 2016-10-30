class Sponsorship < ActiveRecord::Base
  belongs_to :sponsor
  belongs_to :conference
end
