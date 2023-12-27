# frozen_string_literal: true

# main.rb
require_relative './lib/models/parking'
require_relative './lib/models/vehicle'
require_relative './lib/utils'

LEVELS = 2
ROWS_IN_LEVEL = 4
PLACES_IN_ROW = 10
QUEUE_MAX_SIZE = 10


parking = Parking.new(LEVELS, ROWS_IN_LEVEL, PLACES_IN_ROW)
queue = Queue.new


loop do
  if queue.size < QUEUE_MAX_SIZE
    refused = parking.park_or_refuse(random_type_vehicle)
  else
    puts "Vehicle from the queue"
    refused = parking.park_or_refuse(queue.pop)
  end

  unless refused.nil?
    puts "Vehicle #{refused.id} is in the queue. Queue length is #{queue.size}"
    queue.push(refused)
  end
  break if quit?
  sleep rand(0.1..1.0)
end

puts "quit"

puts "Total money: #{parking.money}"
puts "Total out times: #{parking.out_times}"