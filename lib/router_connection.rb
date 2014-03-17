require_relative './jump_server'
require_relative './connect_directly_to_router'
require_relative './login_to_router'

class RouterConnection

  def initialize(router_name, credentials)
    @router_name = router_name
    @credentials = credentials
  end

  def build
    jump_connection = JumpServer.new(@credentials["jump_box_ip_address"], @credentials["jump_box_username"],@credentials["jump_box_password"])
    connection_to_router = ConnectDirectlyToRouter.new(@router_name, jump_connection)
    LoginToRouter.new(connection_to_router, @credentials["router_username"], @credentials["router_password"])
  end
end
