require 'optparse'
require "hiki2latex/version"
#require "hiki2latex/hikidoc"
require "hiki2latex/hiki2latex"

module Hiki2latex
  class Command

    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @pre=@head=@post=nil
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Hiki2latex::VERSION
          puts opt.ver
        }
        opt.on('-l VALUE','--level','set Level for output section.'){|level| @level=level.to_i}
        opt.on('-p FILE', '--plain','make Plain document.') { |file| plain_doc(file) }
        opt.on('-b FILE', '--bare','make Bare document.') { |file| bare_doc(file) }
        opt.on('--head FILE', 'put headers of maketitle file.') { |file| @head=file }
        opt.on('--pre FILE', 'put preamble file.') { |file| @pre=file }
        opt.on('--post FILE', 'put post file.') { |file| @post=file }
      end
      command_parser.banner = "Usage: hiki2latex [options] FILE"
      command_parser.parse!(@argv)
      #      p @argv
      plain_doc(@argv[0]) if @argv[0]!=nil
      exit
    end

    def plain_doc(file)
      if @pre==nil then
        puts "\\documentclass[12pt,a4paper]{jsarticle}"
        puts "\\usepackage[dvipdfmx]{graphicx}"
      else
        puts File.read(@pre)
      end
      puts "\\begin{document}"
      puts File.read(@head) if @head!=nil
      puts HikiDoc.to_latex(File.read(file))
      puts File.read(@post) if @post!=nil
      puts "\\end{document}"
    end
    def bare_doc(file)
      puts HikiDoc.to_latex(File.read(file),{:level=>@level})
    end

  end
end


=begin
=end

