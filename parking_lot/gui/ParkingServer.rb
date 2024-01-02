#!/usr/bin/env ruby
require 'socket'
require 'websocket/driver'

class ParkingServer
  RECV_SIZE = 1024
  HOST = 'localhost'

  attr_reader :server

  def initialize(port = nil)
    @server = start_server(port)
    @logger = Logger.new(STDOUT)
  end

  def start_server(port)
    ::TCPServer.open(HOST, port || 0)
  end

  def addr
    server.addr
  end

  def handle(socket)
    driver = ::WebSocket::Driver.server(socket, protocols: ['websocket'])
    setup_driver_handlers(driver)

    Thread.new do
      driver.start

      24.times do
        sleep(1)
        driver.text(listen_parking_lot)
      end

      driver.close
    end

    process_socket_data(socket, driver)
  end

  def setup_driver_handlers(driver)
    driver.on(:connect) { driver.start }
    driver.on(:message) { |event| driver.text(listen_parking_lot) }
    driver.on(:close) { |event| handle_close_event(event) }
  end

  def process_socket_data(socket, driver)
    loop do
      begin
        IO.select([socket], [], [], 30) or raise Errno::EWOULDBLOCK
        data = socket.recv(RECV_SIZE)
        break if data.empty?
        driver.parse(data)
      rescue Errno::EWOULDBLOCK, Errno::EAGAIN
        # Resource temporarily unavailable, continue the loop
        next
      rescue Errno::ECONNRESET
        @logger.error("Connection reset by the client")
        break # exit the loop or add your logic for handling the reset
      end
    end
  end

  def handle_close_event(event)
    driver = event.instance_variable_get(:@driver)
    socket = driver.instance_variable_get(:@socket)

    connection_msg = "Connection #{socket ? "with #{socket.addr[2]}" : ''} closed. Code: #{event.code}, Reason: #{event.reason}"
  
    @logger.info(connection_msg)
  end

  def listen
    loop do
      client = server.accept
      @logger.info("Accepted connection from #{client.addr[2]}")
      Thread.new { handle(client) }
    end
  end
end

def listen_parking_lot
  "parking lot data for " + Time.now.to_s
end

t0 = Time.now
server = ParkingServer.new(51282)
puts "ParkingServer is listening on #{server.addr}"
server.listen
puts "ParkingServer finished listening on #{server.addr}, after #{Time.now-t0}s"
