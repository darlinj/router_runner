require "router_runner/version"

require_relative 'connect_directly_to_router'
require_relative 'offlicence'
require_relative 'offlicence_router'

module RouterRunner
  def self.with_connection_details(connection_details)
    connection = RouterConnection.new(connection_details)
    connection.build.connect do |connected_connection|
      yield connected_connection
    end
  end
end



