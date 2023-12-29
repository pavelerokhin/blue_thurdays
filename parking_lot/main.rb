# frozen_string_literal: true

# ParkingServer.rb
require_relative './lib/models/parking'
require_relative './lib/models/vehicle'
require_relative './lib/utils'

LEVELS = 2
ROWS_IN_LEVEL = 2
PLACES_IN_ROW = 8
QUEUE_MAX_SIZE = 10


parking = Parking.new(LEVELS, ROWS_IN_LEVEL, PLACES_IN_ROW)
queue = Queue.new


loop do
  if queue.size == 0
    vehicle = random_type_vehicle
    puts "Vehicle from outside world: #{vehicle.type}"
  else
    vehicle = queue.pop
    puts "Vehicle from the queue: #{vehicle.type}"
  end

  refused = parking.park_or_refuse(vehicle)

  unless refused.nil?
    puts "Vehicle #{refused.id} is in the queue. Queue length is #{queue.size}"
    queue.push(refused)
  end

  if queue.size == QUEUE_MAX_SIZE
    puts "Queue is full. No more vehicles from the outside world allowed."
  end

  break if quit?
  sleep rand(0.1..0.2)
end

puts "quit"

puts "Total money: #{parking.money}"
puts "Total out times: #{parking.out_times}"