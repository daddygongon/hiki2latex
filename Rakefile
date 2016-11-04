require "bundler/gem_tasks"
require 'yard'
require "rake/testtask"
require 'fileutils'
p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

task :default do
  system 'rake -T'
end

desc "make documents by yard"
task :yard => [:hiki2md] do
  YARD::Rake::YardocTask.new
end

desc "transfer hikis/*.hiki to wiki"
task :hiki2md do
  files = Dir.entries('hikis')
  files.each{|file|
    name=file.split('.')
    case name[1]
    when 'hiki'
      p command="hiki2md hikis/#{name[0]}.hiki > #{basename}.wiki/#{name[0]}.md"
      system command
    when 'gif','png','pdf'
      FileUtils.cp("hikis/#{file}","#{basename}.wiki/#{file}",:verbose=>true)
      FileUtils.cp("hikis/#{file}","doc/#{file}",:verbose=>true)
    end
  }
  readme_en="#{basename}.wiki/README_en.md"
  readme_ja="#{basename}.wiki/README_ja.md"
  if File.exists?(readme_en)
    FileUtils.cp(readme_en,"./README.md",:verbose=>true)
  elsif File.exists?(readme_ja)
    FileUtils.cp(readme_ja,"./README.md",:verbose=>true)
    FileUtils.cp(readme_ja,"#{basename}.wiki/Home.md",:verbose=>true)
  end
end

desc "Make related report."
task :make_texes do
p  files = Dir.entries('hikis')
  files.each{|file|
    next if file.include?('Readme')
    name=file.split('.')
    case name[1]
    when 'hiki'
      p command="hiki2latex -l 3 --listings -b hikis/#{name[0]}.hiki > latexes/#{name[0]}.tex"
      system command
    when 'gif','png','pdf'
      FileUtils.cp("hikis/#{file}","latexes/#{file}",:verbose=>true)
    end
  }
  source = File.join('hikis',basename+'.hiki')
  target = File.join('latexes',basename+'.tex')
  p command= "hiki2latex --listings --head latexes/head.tex --post latexes/post.tex -p #{source} > #{target}"
  system command

  exit
end

def kill_head_line(file_name)
  cont = File.readlines(file_name)
  unless cont[0]=~/\tableofcontents/ then
    file = File.open(file_name,'w')
    file.puts cont[1..-1]
    file.close
  end
end
