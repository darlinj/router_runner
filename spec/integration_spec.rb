require "spec_helper"

describe "running a command on a router" do
  let(:telnet_connection) { double(:telnet_connection, puts: "stuff", waitfor: true) }
  let(:router_connection) { double(:router_connection) }

  before do
    Net::SSH::Telnet.stub(:new).and_return(telnet_connection)
    telnet_connection.stub(:puts).with("telnet router1").and_return router_connection
  end

  it "should send the command to the router" do
    connection_details = {router_username: "fred", 
                          router_password: "secret", 
                          router_hostname: "router1", 
                          jump_box_username: "bill", 
                          jump_box_password: "real_secret", 
                          jump_box_ip_address: "1.2.3.4"}
    result = ""
    RouterRunner.with_connection_details(connection_details) do | router |
      result = router.run("some command")
    end
    expect(result).to eq("Some stuff from a router")
  end
end

