require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "gem upload"
task :upload do
  system "rsync -auvz -e ssh pkg/ dmz0:~/Sites/nishitani0/gems/gems/"
  print "command at dmz0:cd ~/Sites/nishitani0/gems \n"
  print "command at dmz0:gem generate_index \n"
  system "ssh dmz0"
end

