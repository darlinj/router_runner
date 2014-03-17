require 'rspec/core/rake_task'

task :default => [ :"test:all" ]

namespace :test do
  desc 'Run RSpec tests'
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = %w[--color --format documentation]
    task.pattern    = 'spec/*_spec.rb'
  end

  task :all => [ :spec ]
end
