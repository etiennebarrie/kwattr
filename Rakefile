begin
  require "bundler/gem_tasks"
rescue LoadError
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :examples do
  ruby "test.rb"
end

task :benchmark do
  ruby "benchmark.rb"
end

task :default => [:examples, :spec, :benchmark]
