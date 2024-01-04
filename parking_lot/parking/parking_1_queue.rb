# frozen_string_literal: true

require_relative './models/parking'
require_relative './models/vehicle'
require_relative './utils'


class Parking1Queue
  def initialize(levels,
                 rows_in_level,
                 places_in_row,
                 queue_max_size,
                 vehicles_arrive_hours_distribution,
                 leave_parking_hours_distribution)
    @logger = Logger.new(STDOUT, progname: 'queue')
    @mutex = Mutex.new

    @max_queue_size = queue_max_size
    @vehicles_arrive_hours_distribution = vehicles_arrive_hours_distribution
    @leave_parking_hours_distribution = leave_parking_hours_distribution

    @parking = Parking.new(levels, rows_in_level, places_in_row)
    @queue = Queue.new

    @logger.info("#{GREEN}parking with one queue is ready#{RESET}")
  end

  def run
    loop do
      # vehicles coming from the outside world and enter the queue
      if @queue.size == @max_queue_size
        @logger.info("#{RED}QUEUE IS FULL. No more vehicles from the outside world are allowed.#{RESET}")
        break
      end

      @queue.push(random_type_vehicle(@leave_parking_hours_distribution))
      vehicle = @queue.pop

      refused = @parking.park_or_refuse(vehicle)
      unless refused.nil?
        @logger.info("#{refused.type} has been refused and pushed is in the queue #{MAGENTA}(size: #{@queue.size})#{RESET}") if @queue.size > 1
        @queue.push(refused)
      end

      @logger.info("#{RED}quit simulation with Q pressed#{RESET}") && break if quit?

      wait_for_next_vehicle = rand(@vehicles_arrive_hours_distribution)
      sleep wait_for_next_vehicle
      @logger.info("next vehicle from the outside world arrived in #{wait_for_next_vehicle.round(2)} hours")
    end

    display_statistics
  end

  def snapshot
    @mutex.synchronize do
      return {
        'parking_space': @parking.parking_space,
        'queue': @queue.size,
        'money': @parking.money,
        'out_times': @parking.out_times
      }
    end
  end

  private

  def display_statistics
    @logger.info("#{LIGHT_YELLOW}*******************************")
    @logger.info(" - Total money: #{@parking.money.round(2)}")
    @logger.info(" - Vehicles served: #{@parking.out_times.length}")
    @logger.info("*******************************#{RESET}")

  end
end
