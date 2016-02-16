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

desc "test using unit/test"
Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end

desc "all procedure for release."
task :update do
  system 'emacs ./lib/hiki2latex/version.rb'
  system 'git add -A'
  system 'git commit'
  system 'git push -u origin master'
  print 'in kwansei.ac.jp, you need setenv for proxy.'
  print 'setenv HTTP_PROXY http://proxy.kwansei.ac.jp:8080'
  print 'setenv HTTP_PROXY http://proxy.ksc.kwansei.ac.jp:8080'
  system 'bundle exec rake release'
end
