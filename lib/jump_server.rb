require 'net/ssh/telnet'

class JumpServer

  def initialize ip_address, username, password, debug = false, debug_output_file=""
    @ip_address = ip_address
    @username = username
    @password = password
    @debug_output_file = debug_output_file
    @debug = debug
  end

  def connect
    @session = Net::SSH::Telnet.new(ssh_options)
    confirm_login
    yield @session
    @session.close
  end

private

  def ssh_options
    @ssh_options ||= begin
                       ssh_options = { "Host"      => @ip_address,
                                       "Username"  => @username,
                                       "Password"  => @password,
                                       "Prompt"    =>  /: $/
                       }
                       ssh_options["Dump_log"] = @debug_output_file if @debug = true
                       ssh_options
                     end
  end

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

  def confirm_login
    send_then_wait_for 'Y', /Please hit <return> to continue/
    send_then_wait_for '', /js01:/
  end
end
