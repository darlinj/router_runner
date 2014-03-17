require "spec_helper"

describe Offlicence, "#routes" do
  let(:router_credentials)   { { ip_address: "9.9.9.9", username: "bert", password: "very_secret"} }
  let(:jump_box_credentials) { { ip_address: "1.2.3.4", username: "fred", password: "secret"} }
  let(:router_connection)    { double(RouterConnection) }
  let(:router)               { double(OfflicenceRouter, routes: "routes for the router") }

  before do
    RouterConnection.stub(:new).and_return(router_connection)
    OfflicenceRouter.stub(:new).and_return(router)
  end

  def do_request credentials
    Offlicence.new(jump_box_credentials).routes(credentials)
  end

  it "creates a new router connection to get to the router" do
    RouterConnection.should_receive(:new).with(jump_box_credentials, router_credentials)
    do_request router_credentials
  end

  it "connects to the router using the router connection" do
    OfflicenceRouter.should_receive(:new).with(router_connection)
    do_request router_credentials
  end

  it "requests the routes for that router" do
    router.should_receive(:routes)
    do_request router_credentials
  end

  it "uses the jump_box credentials if there are none supplied for the router itself" do
    partial_credentials = { ip_address: "6.6.6.6" }
    RouterConnection.should_receive(:new).with(jump_box_credentials, { ip_address: "6.6.6.6", username: "fred", password: "secret"})
    do_request partial_credentials
  end
end
