# frozen_string_literal: true

require 'open-uri'
require 'launchy'

require_relative './gui/backend/gui_server'
require_relative './parking/parking_1_queue'


logger = Logger.new(STDOUT)

parking_with_1_queue = Parking1Queue.new(levels = 1,
                            rows_in_level=5,
                            places_in_row = 10,
                            queue_max_size = 50,
                            vehicles_arrive_hours_distribution = 0.1..0.2,
                            leave_parking_hours_distribution = 7.5..8.5)

gui_server = GuiServer.new(parking = parking_with_1_queue,
                           port = 51282,
                           gui_path = "./gui/frontend/index.html")
gui_server.open_browser
gui_server.listen_and_serve

sleep(2) # wait while the browser is opening

# run the simulation
parking_with_1_queue.run
