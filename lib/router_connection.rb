require_relative 'jump_server'
require_relative 'connect_directly_to_router'
require_relative 'login_to_router'

class RouterConnection

  def initialize(credentials)
    @credentials = Hash[credentials.map{|(k,v)| [k.to_sym,v]}]
  end

  def build
    jump_connection = JumpServer.new(@credentials[:jump_box_ip_address], @credentials[:jump_box_username],@credentials[:jump_box_password], @credentials[:debug_output], @credentials[:debug_output_file])
    connection_to_router = ConnectDirectlyToRouter.new(@credentials[:router_hostname], jump_connection)
    LoginToRouter.new(connection_to_router, @credentials[:router_username], @credentials[:router_password])
  end
end
