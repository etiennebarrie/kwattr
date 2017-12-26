require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task :examples do
  ruby "test.rb"
end

task :benchmark do
  ruby "benchmark.rb"
end

task :default => [:examples, :spec, :benchmark]
