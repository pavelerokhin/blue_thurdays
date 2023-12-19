# frozen_string_literal: true

class Parking
  attr_accessor :parking_space, :levels, :rows_in_level, :places_in_row

  def initialize(levels, rows_in_level, places_in_row)
    validate(levels, rows_in_level, places_in_row)
    @levels = levels
    @rows_in_level = rows_in_level
    @places_in_row = places_in_row
    @parking_space = Array.new(levels) { Array.new(rows_in_level) { Array.new(places_in_row) } }
  end

  def park_or_refuse(vehicle)
    # a comment here
    parking_place = find_parking_place(vehicle.type.size)
    if parking_place.nil?
      'Sorry, there are no empty places for now'
    else
      park(vehicle, parking_place)
      "Your vehicle is parked at level #{parking_place[0] + 1}, row #{parking_place[1] + 1}, place #{parking_place[2] + 1}"
    end
  end

  def exit_parking(vehicle)
    @parking_space[vehicle.parking_place[0]]\
                  [vehicle.parking_place[1]]\
                  [vehicle.parking_place[2]..vehicle.parking_place[2]+vehicle.parking_place[3]] = nil

    vehicle.pay
    vehicle.finish
  end

  private

  def validate(levels, rows_in_level, places_in_row)
    if levels < 1 || rows_in_level < 1 || places_in_row < 1
      raise ArgumentError, 'Invalid parking size'
    end
  end

  def find_parking_place(vehicle_size)
    parking_size = 0

    @parking_space.each_with_index { |level, level_index|
      level.each_with_index { |row, row_index|
        row.each_with_index { |place, place_index|
          if place.nil?
            parking_size += 1
          else
            parking_size = 0
          end
          if parking_size == vehicle_size
            return [level_index, row_index, place_index, parking_size]
          end
        }
        parking_size = 0
      }
      parking_size = 0
    }
  end

  def park(vehicle, parking_place)
    vehicle.park(parking_place)
    @parking_space[parking_place[0]][parking_place[1]][parking_place[2]] = vehicle.id
  end


end