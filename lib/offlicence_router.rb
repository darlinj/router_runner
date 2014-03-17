require_relative './router_connection'

class RouterAdminError < StandardError
end

class OfflicenceRouter

  class << self

    def fetch_routes(aggregation_router_name)
      @aggregation_router_name = aggregation_router_name
      grab_routes router_connection
    end

    private

    def load_credentials
      YAML.load(File.open("#{File.dirname(__FILE__)}/../../config/connection_credentials.yml"))
    end

    def router_connection
      RouterConnection.new(@aggregation_router_name, load_credentials)
    end

    def grab_routes connection
      response = ""
      connection.build.connect do |connected_connection|
        if new_aggregation_router
          connected_connection.puts 'show ip route bgp'
        else
          connected_connection.puts 'show ip route static'
        end
        response = connected_connection.waitfor(/[#>]$/)
      end
      response
    end

    def new_aggregation_router
      @aggregation_router_name.split("_")[1] == "new"
    end

  end

end
