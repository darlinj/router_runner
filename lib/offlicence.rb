require_relative "connect_directly_to_router"
require_relative "login_to_router"
require_relative "router_connection"
require_relative "jump_server"


class Offlicence

  def initialize jump_box_credentials
    @jump_box_credentials = jump_box_credentials
  end

  def routes router_credentials
    @router_credentials = router_credentials
    router_connection = RouterConnection.new(@jump_box_credentials, combined_credentials)
    OfflicenceRouter.new(router_connection).routes
  end

  private

  def combined_credentials
    credentials = {}
    credentials[:ip_address] = @router_credentials[:ip_address]
    credentials[:username] = @router_credentials[:username] || @jump_box_credentials[:username]
    credentials[:password] = @router_credentials[:password] || @jump_box_credentials[:password]
    credentials
  end

end
