require "spec_helper"

describe RouterConnection, "#connect" do
  let(:jump_server)             { double(:jump_server).as_null_object }

  let(:router_connection)       { double(:router_connection).as_null_object }
  let(:credentials)      { {"jump_box_ip_address" => "1.1.1.1", 
                            "jump_box_username" => "pooh",
                            "jump_box_password" => "meh",
                            "router_username" => "foo",
                            "router_password" => "bar"
                         } }

  before do
    JumpServer.stub(:new).with("1.1.1.1", "pooh", "meh").and_return(jump_server)
    ConnectDirectlyToRouter.stub(:new).with("an_address", jump_server).and_return(router_connection)
  end

  it "logs into the router" do
    LoginToRouter.should_receive(:new).with(router_connection, "foo", "bar")
    RouterConnection.new("an_address", credentials).build
  end

end
