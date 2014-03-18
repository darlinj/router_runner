# RouterRunner

This is a simple gem that allows you to run commands on routers that are behind a jump server.

This probably only works with cisco routers and for only a subset of commands.  Please feel free to extend it.

## Installation

Add this line to your application's Gemfile:

    gem 'router_runner'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install router_runner

## Usage

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

## Contributing

1. Fork it ( http://github.com/<my-github-username>/router_runner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
