# -*- coding: utf-8 -*-
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
      @listings=false
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
        opt.on('--listings', 'use listings.sty for preformat with style.') {@listings=true }
      end
      command_parser.banner = "Usage: hiki2latex [options] FILE"
      command_parser.parse!(@argv)
      #      p @argv
      plain_doc(@argv[0]) if @argv[0]!=nil
      exit
    end

    def plain_doc(file)
      if @listings==true then
        puts listings_str
      elsif @pre==nil then
        puts "\\documentclass[12pt,a4paper]{jsarticle}"
        puts "\\usepackage[dvipdfmx]{graphicx}"
      else
        puts File.read(@pre)
      end
      puts "\\begin{document}"
      puts File.read(@head) if @head!=nil
      puts HikiDoc.to_latex(File.read(file),{:listings=>@listings})
      puts File.read(@post) if @post!=nil
      puts "\\end{document}"
    end

    def bare_doc(file)
      puts HikiDoc.to_latex(File.read(file),{:level=>@level,:listings=>@listings})
    end

    def listings_str
      str = <<"EOS"
\\documentclass[12pt,a4paper]{jsarticle}
\\usepackage[dvipdfmx]{graphicx}
\\usepackage[dvipdfmx]{color}
\\usepackage{listings}

\\lstset{
  basicstyle={\\small\\ttfamily},
  identifierstyle={\\small},
  commentstyle={\\small\\itshape\\color{red}},
  keywordstyle={\\small\\bfseries\\color{cyan}},
  ndkeywordstyle={\\small},
  stringstyle={\\small\\color{blue}},
  frame={tb},
  breaklines=true,
  numbers=left,
  numberstyle={\\scriptsize},
  stepnumber=1,
  numbersep=1zw,
  xrightmargin=0zw,
  xleftmargin=3zw,
  lineskip=-0.5ex
}
\\lstdefinestyle{customCsh}{
  language={csh},
  numbers=none,
}
\\lstdefinestyle{customRuby}{
  language={ruby},
  numbers=left,
}
EOS
    end

  end
end

