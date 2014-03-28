require 'spec_helper'

describe ConnectedTelnetSession, ".run" do
  let(:session) { double(:session, puts: true, waitfor: true) }

  it "should run the command" do
    session.should_receive(:puts).with("some command")
    ConnectedTelnetSession.new(session).run("some command")
  end

  it "should wait for the result"  do
    session.should_receive(:waitfor).with(/[#>]\s*$/)
    ConnectedTelnetSession.new(session).run("some command")
  end
end
