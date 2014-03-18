require "spec_helper"

describe "running a command on a router" do
  let(:telnet_connection) { double(:telnet_connection, puts: "stuff", waitfor: true) }

  before do
    Net::SSH::Telnet.stub(:new).and_return(telnet_connection)
  end

  it "should send the command to the router" do
    connection_details = {router_username: "fred", 
                          router_password: "secret", 
                          router_hostname: "router1", 
                          jump_server_username: "bill", 
                          jump_server_password: "real_secret", 
                          jump_server_ip: "1.2.3.4"}
    result = ""
    RouterRunner.with_connection_details(connection_details) do | router |
      result = router.run("some command")
    end
    expect(result).to eq("Some stuff from a router")
  end
end

