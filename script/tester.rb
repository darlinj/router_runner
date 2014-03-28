#!/usr/bin/env ruby
require 'yaml'
require_relative '../lib/router_runner'
require 'debugger'

creds = YAML.load(File.open("#{File.dirname(__FILE__)}/connection_credentials.yml"))

creds[:router_hostname] = ARGV[0]

RouterRunner.with_connection_details(creds) do | connection |
  result = connection.run("show cdp neighbors detail")
  puts "Result #{result}"
end
