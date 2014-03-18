require "spec_helper"

describe "running a command on a router" do
  it "should send the command to the router" do
    connection_details = {router_username: "fred", 
                          router_password: "secret", 
                          router_hostname: "router1", 
                          jump_server_username: "bill", 
                          jump_server_password: "real_secret", 
                          jump_server_ip: "1.2.3.4"}
    result = ""
    RouterRunner.with_connection_details(connection_details) do | router |
      result = connected_router.run("some command")
    end
    expect(result).to eq("Some stuff from a router")
  end
end

