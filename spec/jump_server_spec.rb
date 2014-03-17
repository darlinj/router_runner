require 'spec_helper'

describe JumpServer, '#connect' do
  let(:ssh_session) { double(:ssh_session).as_null_object  }
  let(:ssh_options) { {"Host"     => "1.2.3.4",
                       "Username" => "a username",
                       "Password" => "a password",
                       "Prompt"   =>  /: $/
                    } }
  let(:jump_server) { JumpServer.new("1.2.3.4", "a username", "a password")        }

  before do
    Net::SSH::Telnet.stub(:new).with(ssh_options).and_return(ssh_session)
  end

  it "logs into the router" do
    ssh_session.stub(:waitfor).with(/Please hit <return> to continue/).and_return("js01: ")
    ssh_session.should_receive(:puts).with('Y').ordered
    ssh_session.should_receive(:waitfor).with(/Please hit <return> to continue/).ordered
    ssh_session.should_receive(:puts).with('').ordered
    ssh_session.should_receive(:waitfor).with(/js01:/).ordered
    jump_server.connect {}
  end

  it 'yields the telnet session' do
    expect { |b| jump_server.connect(&b) }.to yield_with_args(ssh_session)
  end

  it "closes the session" do
    ssh_session.should_receive(:close)
    jump_server.connect {}
  end
end
