#!/usr/bin/env ruby
require 'socket'
require 'websocket/driver'

class EchoServer
  RECV_SIZE = 1024
  HOST = 'localhost'

  attr_reader :server

  def initialize(port = nil)
    @server = start_server(port)
  end

  def start_server(port)
    ::TCPServer.open(HOST, port || 0)
  end

  def port
    server.addr[1]
  end

  def handle(socket)
    driver = ::WebSocket::Driver.server(socket, protocols: ['websocket'])
    setup_driver_handlers(driver)

    Thread.new do
      driver.start
      i = 0

      loop do
        sleep 1
        driver.text(listen_parking_lot)
        i += 1
      end
    end

    process_socket_data(socket, driver)
  end

  def setup_driver_handlers(driver)
    driver.on(:connect) { driver.start }
    driver.on(:message) { |event| driver.text(listen_parking_lot(event.data)) }
    driver.on(:close) { |event| handle_close_event(event) }
  end

  def process_socket_data(socket, driver)
    loop do
      begin
        IO.select([socket], [], [], 30) or raise Errno::EWOULDBLOCK
        data = socket.recv(RECV_SIZE)
        break if data.empty?
        driver.parse(data)
      rescue Errno::EAGAIN
        # Resource temporarily unavailable, continue the loop
        next
      rescue Errno::ECONNRESET
        puts "Connection reset by the client"
        break # exit the loop or add your logic for handling the reset
      end
    end
  end

  def handle_close_event(event)
    driver = event.instance_variable_get(:@driver)
    socket = driver.instance_variable_get(:@socket)

    if socket
      puts "Connection with #{socket.addr[2]} closed. Code: #{event.code}, Reason: #{event.reason}"
    else
      puts "Connection closed. Code: #{event.code}, Reason: #{event.reason}"
    end
  end

  def listen
    loop do
      client = server.accept
      puts "Accepted connection from #{client.addr[2]}"
      Thread.new { handle(client) }
    end
  end
end

def listen_parking_lot
  "parking lot data for " + Time.now.to_s
end

server = EchoServer.new(51282)
puts "EchoServer is listening on #{server.port}"
server.listen