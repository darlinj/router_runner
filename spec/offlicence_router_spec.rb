require 'spec_helper'

describe OfflicenceRouter do

  describe ".fetch_routes" do
    let(:connection)            { double(:connection) }
    let(:login_to_router)       { double(:login_to_router) }
    let(:connected_connection)  { double(:connected_connection) }
    let(:returned_config)       { "foo" }
    let(:connection_credentials){ double(:connection_credentials) }

    before do
      connection.stub(:build).and_return(login_to_router)
      login_to_router.stub(:connect).and_yield(connected_connection)
      connected_connection.stub(:puts)
      connected_connection.stub(:waitfor).with(/[#>]$/).and_return(returned_config)
      RouterConnection.stub(:new).with("router", connection_credentials).and_return(connection)
      RouterConnection.stub(:new).with("router_new", connection_credentials).and_return(connection)
      YAML.stub(:load).and_return(connection_credentials)
      File.stub(:open).and_return( double )
    end

    context "An old aggregation router" do
      it "runs the show ip route static command" do
        connected_connection.should_receive(:puts).with('show ip route static')
        OfflicenceRouter.fetch_routes("router")
      end
    end

    context "An new aggregation router" do
      it "runs the show ip route bgp command" do
        connected_connection.should_receive(:puts).with('show ip route bgp')
        OfflicenceRouter.fetch_routes("router_new")
      end
    end

    it "returns the results of ip route" do
      expect(OfflicenceRouter.fetch_routes("router")).to eq returned_config
    end
  end
end
