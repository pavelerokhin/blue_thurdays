# frozen_string_literal: true

require 'securerandom'


class Vehicle
  attr_accessor :state, :time_in, :time_out, :parking_place, :type, :size, :price, :id, :cashier

  def initialize
    @id = SecureRandom.uuid
    @state = :in_queue
    @parking_place = nil
  end

  def in_queue
    @state = :in_queue
    @in_time = nil
    @out_time = nil
  end

  def park(parking_place, time_in = Time.now)
    @parking_place = parking_place
    @state = :parked
    @in_time = time_in
    @out_time ||= @in_time + rand(2..14) # TODO: make it configurable

    Thread.new do
      loop do
        break unless @out_time.nil? && Time.now >= @out_time
        sleep 0.1 # Adjust the sleep duration as needed
      end
      pay_and_exit
    end
  rescue => e
    puts "Error while parking: #{e.message}"
  end

  def pay_and_exit(out_time = Time.now)
    @state = :out
    @out_time = out_time

    @cashier.pay_and_exit(self, out_time)
  end

  def pay
    time = get_parking_time
    if time
      time * @price
    end
  end

  private

  def get_parking_time
    return unless @out_time && @in_time

    if @out_time.is_a?(Time) && @in_time.is_a?(Time)
      @out_time - @in_time # in seconds
    else
      puts "Error: @time_out and @in_time must be Time objects."
    end
  end
end

class Moto < Vehicle
  def initialize
    super
    @type = :moto
    @size = 1
    @price = 1
  end
end

class Auto < Vehicle
    def initialize
      super
      @type = :auto
      @size = 4
      @price = 2
  end
end

class Bus < Vehicle
  def initialize
    super
    @type = :auto
    @size = 8
    @price = 4
  end
end

def random_type_vehicle
  [Moto, Auto, Bus].sample.new
end

