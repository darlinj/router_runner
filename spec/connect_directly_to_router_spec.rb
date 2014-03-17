require 'spec_helper'

describe ConnectDirectlyToRouter, '#connect' do
  let(:connection)                  { double(:connection) }
  let(:connected_connection)        { double(:connected_connection).as_null_object }
  let(:connect_directly_to_router)  { ConnectDirectlyToRouter.new('an_ip_address', connection) }

  before do
    connection.stub(:connect).and_yield(connected_connection)
  end

  it 'connects to the ip address provided' do
    connected_connection.should_receive(:puts).with('telnet an_ip_address')
    connect_directly_to_router.connect {}
  end

  it 'yields the connected_connectio' do
    expect { |b| connect_directly_to_router.connect(&b) }.to yield_with_args(connected_connection)
  end
end
