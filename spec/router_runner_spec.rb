require "spec_helper"

describe RouterConnection, "#connect" do
  let(:router_connection)    { double(:router_connection, build: built_connection) }
  let(:built_connection)     { double(:built_connection, connect: connected_connection) }
  let(:connected_connection) { double }
  let(:connection_details) { {router_username: "fred", router_password: "secret", router_hostname: "router1", jump_server_username: "bill", jump_server_password: "real_secret", jump_server_ip: "1.2.3.4"} }

  before do
    RouterConnection.stub(:new).and_return(router_connection)
  end

  it "runs the command on the router" do
    RouterConnection.should_receive(:new).with(connection_details)
    RouterRunner.with_connection_details(connection_details)
  end

  it "builds the connection" do
    router_connection.should_receive(:build)
    RouterRunner.with_connection_details(connection_details)
  end

  it "connects the connection" do
    built_connection.should_receive(:connect)
    RouterRunner.with_connection_details(connection_details)
  end
  
  it "should run the command" do
    built_connection.stub(:connect).and_yield connected_connection
    connected_connection.should_receive(:run).with("some command")
    RouterRunner.with_connection_details(connection_details) do |c|
      c.run("some command")
    end
  end
end

