# frozen_string_literal: true

require 'open-uri'
require 'launchy'

require_relative './gui/GuiServer'
require_relative './parking/parking_1_queue'


logger = Logger.new(STDOUT)

parking = Parking1Queue.new(levels = 3,
                            rows_in_level= 10,
                            places_in_row = 10,
                            queue_max_size = 100,
                            outside_world_distribution = [0.1..1.5],
                            parking_distribution = [1.0..2.5])

Thread.new do
  t0 = Time.now

  gui_parking_server = GuiServer.new(51282, ParkingSnapshotHandler.new(parking))
  logger.info("gui server is listening on #{gui_parking_server.addr}")

  gui_parking_server.listen
  logger.info("gui server finished listening on #{gui_parking_server.addr}, after #{Time.now-t0}s")
end

# open chrome browser with the gui ./gui/index.html
gui_path = File.expand_path('./gui/index.html')

# Open Chrome browser with the GUI
Launchy.open("file://#{gui_path}", :browser => 'google-chrome')

sleep(10)

# run the simulation
parking.run

