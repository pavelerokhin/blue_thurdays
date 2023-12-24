# frozen_string_literal: true

# main.rb
require_relative './lib/models/parking'
require_relative './lib/models/vehicle'
require_relative './lib/workers/ParkingWithOneQueue'

LEVELS = 2
ROWS_IN_LEVEL = 4
PLACES_IN_ROW = 10

N_VEHICLES = 10

def quit_requested?
  IO.select([$stdin], nil, nil, 0.1) && $stdin.getc == 'q'
end

def main_loop
  loop do
    Time.sleep(rand(0..3))
    puts "Looping..."
    break if quit_requested?
  end
  puts "Exiting the loop."
end

parking_lot = Parking.new(LEVELS, ROWS_IN_LEVEL, PLACES_IN_ROW)
parking = ParkingWithOneQueue.new(parking_lot)

N_VEHICLES.times do
  # Time.sleep(rand(1..2))
  parking.park_or_refuse(random_type_vehicle)
end

puts "Total money: #{parking_lot.money}"