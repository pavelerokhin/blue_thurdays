# frozen_string_literal: true

# main.rb
require_relative './lib/models/parking'
require_relative './lib/models/vehicle'
require_relative 'lib/enums/vehicle_type'


LEVELS = 2
ROWS_IN_LEVEL = 4
PLACES_IN_ROW = 10

N_VEHICLES = 10

parking_lot = Parking.new(2, 4, 10)

N_VEHICLES.times do
  parking_lot.park_or_refuse(random_type_vehicle)
end

puts parking_lot.parking_space
