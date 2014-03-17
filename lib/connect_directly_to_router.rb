class ConnectDirectlyToRouter

  def initialize(ip_address, connection)
    @ip_address = ip_address
    @connection = connection
  end

  def connect
    @connection.connect do |connected_connection|
      connected_connection.puts "telnet #{@ip_address}"
      yield connected_connection
    end
  end
end
