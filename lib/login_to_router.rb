require_relative 'connected_telnet_session'

class LoginToRouter

  class ConnectionError < StandardError ;end

  def initialize connection_to_router, username, password
    @connection_to_router = connection_to_router
    @username = username
    @password = password
  end

  def connect
    @connection_to_router.connect do |session|
      @session = session
      login
      put_router_into_unprivileged_mode
      setup_terminal
      yield ConnectedTelnetSession.new(@session)
      logout
    end
  end

private

  def send_then_wait_for command, expected_response
    @session.puts command
    waitfor_timed expected_response
  end

  def waitfor_timed(expected_response)
    begin
      Timeout::timeout(20) { @session.waitfor(expected_response) }
    rescue Timeout::Error
      raise ConnectionError.new("Unable to run command")
    end
  end

  def login
    response = waitfor_timed(/Username: |Password: |[#>]$/)
    if response =~ /Username: /
      send_then_wait_for @username, /Password: /
      send_then_wait_for @password, /[#>]\s*$/
    end
  end


  def put_router_into_unprivileged_mode
    response = send_then_wait_for "", /[#>]\s*$/
    if response =~ /config-.*if\)\#/
      exit_interface_mode
    end
    if response =~ /config\)\#/
      exit_config_mode
    end
    if response =~ /[#]$/
      exit_privileged_mode
    end
  end

  def setup_terminal
    send_then_wait_for 'term len 0', /[#>]\s*$/
    send_then_wait_for 'set length 0', /[#>]\s*$/
  end

  def exit_interface_mode
    send_then_wait_for "exit", /config\)\#$/
    exit_config_mode
  end

  def exit_config_mode
    send_then_wait_for "exit", /\#$/
    exit_privileged_mode
  end

  def exit_privileged_mode
    send_then_wait_for "disable", /\>$/
  end

  def logout
    send_then_wait_for "logout", /.*/
  end

end
