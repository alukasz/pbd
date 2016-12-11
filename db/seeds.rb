require "faker"
require "as-duration"
require "activerecord-import/base"
require "benchmark"
require_relative "../lib/pbd"
require_relative "seeds/support"
extend Support

ActiveRecord::Import.require_adapter("mysql2")
ActiveRecord::Base.logger = nil

class Fixnum
  def vary(percent = 10)
    value = rand(1..(self/percent))
    rand > 0.5 ? self - value : self + value
  end
end

BATCH_SIZE = 1000
MULTIPLIER = 10

CONFERENCES = (MULTIPLIER * 10).vary
USERS = (MULTIPLIER * 500).vary
VENUES = (CONFERENCES * 2).vary
ROOMS = (CONFERENCES * 5).vary
MIN_SCHEDULE_DAYS = 2
MAX_SCHEDULE_DAYS = 8
TOPICS = 50
SPONSORS = (CONFERENCES * 2).vary
SPONSORSHIPS = (CONFERENCES * 7).vary
TALKS = (CONFERENCES * 20).vary
REVIEWS = (CONFERENCES * 50).vary
REVIEW_ASSIGNMETS = (REVIEWS / 10).vary
REGISTRATIONS = (CONFERENCES * 300).vary

total = Benchmark::Tms.new
Benchmark.benchmark do |bm|
  Dir[File.join(File.dirname(__FILE__), 'seeds', '*_*.rb')].sort.each do |seed|
    part = bm.report(File.basename(seed, '.seeds.rb') + ": ") do
      load seed
    end
    total += part
  end
  print "total: "
  [total]
end
