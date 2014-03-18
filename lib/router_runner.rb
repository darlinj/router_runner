require "router_runner/version"

require_relative 'router_connection'

module RouterRunner
  def self.with_connection_details(connection_details)
    connection = RouterConnection.new(connection_details)
    connection.build.connect do |connected_connection|
      yield connected_connection
    end
  end
end



