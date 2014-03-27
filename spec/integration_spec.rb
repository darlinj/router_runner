require "spec_helper"
require 'fileutils'

describe "running a command on a router" do
  let(:telnet_connection) { double(:telnet_connection, puts: "stuff", waitfor: true, close: true) }
  let(:router_connection) { double(:router_connection) }
  let(:ssh_options)       { { "Host"      => "1.2.3.4",
                              "Username"  => "bill",
                              "Password"  => "real_secret",
                              "Prompt"    =>  /: $/,
                              "Dump_log"  => "router_runner.log" 
                          } }

  before do
    Net::SSH::Telnet.stub(:new).with(ssh_options).and_return(telnet_connection)
    telnet_connection.stub(:waitfor).with(/[#>]$/).and_return "Some stuff from a router"
  end

  def run_command command
    connection_details = {router_username: "fred", 
                          router_password: "secret", 
                          router_hostname: "router1", 
                          jump_box_username: "bill", 
                          jump_box_password: "real_secret", 
                          jump_box_ip_address: "1.2.3.4",
                          debug_output: true,
                          debug_output_file: "router_runner.log"
                          }

    result = ""
    RouterRunner.with_connection_details(connection_details) do | router |
      result = router.run(command)
    end
    result
  end

  it "should send the command to the router" do
    result = run_command "some command"
    expect(result).to eq("Some stuff from a router")
  end
end

