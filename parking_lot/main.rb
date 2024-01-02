# frozen_string_literal: true

# ParkingServer.rb
require_relative './lib/models/parking'
require_relative './lib/models/vehicle'
require_relative './lib/utils'

LEVELS = 2
ROWS_IN_LEVEL = 2
PLACES_IN_ROW = 4
QUEUE_MAX_SIZE = 10


parking = Parking.new(LEVELS, ROWS_IN_LEVEL, PLACES_IN_ROW)
queue = Queue.new
logger = Logger.new(STDOUT)

loop do

  vehicle = if queue.size < QUEUE_MAX_SIZE
    vehicle = random_type_vehicle
    queue.push(vehicle)
    logger.info("Vehicle #{vehicle.type} from the outside world is in the queue (size: #{queue.size})")
    queue.pop
  else
    logger.info("#{RED}Queue is full. No more vehicles from the outside world are allowed.#{RESET}")
    break
  end

  refused = parking.park_or_refuse(vehicle)

  unless refused.nil?
    queue.push(refused)
    logger.info("#{refused.type} is in the queue (size: #{queue.size})")
  end

  break if quit?
  sleep rand(0.1..3.0)
end

puts "quit"

puts "Total money: #{parking.money}"
puts "Total out times: #{parking.out_times}"