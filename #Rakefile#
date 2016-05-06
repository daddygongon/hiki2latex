require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/testtask"
require 'yard'
require 'systemu'

#task :default => :test
task :default do
  system 'rake -T'
end


desc "make documents by yard"
task :yard do
  system "hiki2md docs/readme.hiki > docs/README.en.md"
  system "hiki2md docs/readme.ja.hiki > docs/README.ja.md"
  YARD::Rake::YardocTask.new
end

RSpec::Core::RakeTask.new(:spec)

desc "all procedure for release."
task :update =>[:setenv] do
  system 'emacs ./lib/hiki2latex/version.rb'
  system 'git add -A'
  system 'git commit'
  system 'git push -u origin master'
  system 'bundle exec rake release'
end

desc "setenv for release from Kwansei gakuin."
task :setenv do
#  status, stdout, stderr  = systemu "scselect \| grep \'\*\' |grep KG"
#  puts stdout
#  p stdout != nil
#  if stdout != nil then
    p command='setenv HTTP_PROXY http://proxy.ksc.kwansei.ac.jp:8080'
    system command
    p command='setenv HTTPS_PROXY http://proxy.ksc.kwansei.ac.jp:8080'
    system command
#  end
end