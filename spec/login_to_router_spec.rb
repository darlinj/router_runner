require 'spec_helper'

describe LoginToRouter, '#connect' do
  let(:telnet_connection) { double(:telnet_connection) }
  let(:telnet_session) { double(:telnet_session).as_null_object }
  let(:login_to_router) { LoginToRouter.new(telnet_connection, "a username", "a password") }

  before do
    telnet_connection.stub(:connect).and_yield(telnet_session)
  end

  it 'opens and closes the session' do
    telnet_session.stub(:waitfor).with(/Username: |Password: |[#>]$/).and_return("Username: ")
    telnet_session.stub(:waitfor).with(/Password: /).and_return("Password: ")
    telnet_session.should_receive(:waitfor).with(/Username: |Password: |[#>]$/).ordered
    telnet_session.should_receive(:puts).with('a username').ordered
    telnet_session.should_receive(:waitfor).with(/Password: /).ordered
    telnet_session.should_receive(:puts).with('a password').ordered
    telnet_session.should_receive(:waitfor).with(/[#>]$/).ordered
    telnet_session.should_receive(:puts).with('').ordered
    telnet_session.should_receive(:waitfor).with(/[#>]$/).ordered
    telnet_session.should_receive(:puts).with('term len 0').ordered
    telnet_session.should_receive(:waitfor).with(/[#>]$/).ordered
    telnet_session.should_receive(:puts).with("logout").ordered
    login_to_router.connect {}
  end

  it 'opens the session when we are already logged on to the router' do
    telnet_session.stub(:waitfor).with(/Username: |Password: |[#>]$/).and_return("a_router>")

    telnet_session.should_receive(:waitfor).with(/Username: |Password: |[#>]$/).ordered
    telnet_session.should_receive(:puts).with('').ordered
    telnet_session.should_receive(:waitfor).with(/[#>]$/).ordered

    telnet_session.should_receive(:puts).with('term len 0').ordered
    telnet_session.should_receive(:waitfor).with(/[#>]$/).ordered
    telnet_session.should_receive(:puts).with("logout").ordered
    login_to_router.connect {}
  end

  it 'drops back to unprivileged mode from privilaged mode' do
    telnet_session.stub(:waitfor).with(/[#>]$/).and_return("Router1#")

    telnet_session.should_receive(:puts).with("disable").ordered
    telnet_session.should_receive(:waitfor).with(/\>$/).ordered
    login_to_router.connect {}
  end

  it 'drops back to unprivileged mode from config mode' do
    telnet_session.stub(:waitfor).with(/[#>]$/).and_return("Router1(config)#")
    telnet_session.stub(:waitfor).with(/\>$/)

    telnet_session.should_receive(:puts).with("exit").ordered
    telnet_session.should_receive(:waitfor).with(/\#$/).ordered
    login_to_router.connect {}
  end

  it 'drops back to unprivileged mode from interface config mode' do
    telnet_session.stub(:waitfor).with(/[#>]$/).and_return("Router1(config-if)#")
    telnet_session.stub(:waitfor).with(/\>$/)
    telnet_session.stub(:waitfor).with(/config\)\#$/)

    telnet_session.should_receive(:puts).with("exit").ordered
    telnet_session.should_receive(:waitfor).with(/config\)\#$/).ordered
    login_to_router.connect {}
  end

  it "raises an error if waiting for a router prompt times out" do
    telnet_session.stub(:waitfor).with(/Username: |Password: |[#>]$/).and_raise(Timeout::Error)
    expect { login_to_router.connect {} }.to raise_error(LoginToRouter::ConnectionError)
  end

  it 'yields the telnet session' do
    expect { |b| login_to_router.connect(&b) }.to yield_with_args(telnet_session)
  end
end

