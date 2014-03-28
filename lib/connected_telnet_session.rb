class ConnectedTelnetSession
  def initialize session
    @session = session
  end

  def run command
    send_then_wait_for(command, /[#>]\s*$/)
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

end
