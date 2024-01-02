#!/usr/bin/env ruby
require 'socket'
require 'websocket/driver'

class GuiServer
  def initialize(port = nil, handler)
    @port = port
    @handler = handler

    @host = 'localhost'
    @server = start_server(port)
    @recv_size = 1024

    @logger = Logger.new(STDOUT)
  end

  def addr
    @host + ':' + @server.addr[1].to_s
  end

  def listen
    @logger.info("Waiting for connections on #{addr}")
    loop do
      client = @server.accept
      @logger.info("Accepted connection from #{client.addr[2]}")
      Thread.new { handle(client) }
    end
  end

  private

  def start_server(port)
    ::TCPServer.open("0.0.0.0", port || 0)
  end

  def handle(socket)
    driver = ::WebSocket::Driver.server(socket, protocols: ['websocket'])
    setup_driver_handlers(driver)

    Thread.new do
      driver.start

      loop do
        sleep(1)
        driver.text(@handler.get_snapshot.to_s)
        break if quit?
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
        data = socket.recv(@recv_size)
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
end

