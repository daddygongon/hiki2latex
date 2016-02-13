require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/testtask"
require 'yard'

#task :default => :test
task :default do
  system 'rake -T'
end


YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:spec)



