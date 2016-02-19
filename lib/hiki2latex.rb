# -*- coding: utf-8 -*-
require 'optparse'
require "hiki2latex/version"
#require "hiki2latex/hikidoc"
require "hiki2latex/hiki2latex"
require 'pp'

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
        puts listings_preamble
      elsif @pre==nil then
        puts "\\documentclass[12pt,a4paper]{jsarticle}"
        puts "\\usepackage[dvipdfmx]{graphicx}"
      else
        puts File.read(@pre)
      end
      puts "\\begin{document}"
      puts File.read(@head) if @head!=nil
      plain_tex = HikiDoc.to_latex(File.read(file),{:listings=>@listings})
      puts mod_abstract(plain_tex)
      puts File.read(@post) if @post!=nil
      puts "\\end{document}"
    end

    def bare_doc(file)
      bare_doc = HikiDoc.to_latex(File.read(file),{:level=>@level,:listings=>@listings})
      puts kill_head_tableofcontents(bare_doc)
    end

    def kill_head_tableofcontents(text)
      text.gsub!(/^\\tableofcontents/,'')
    end

    def mod_abstract(text)
      abstract,section = [],[]
      content = ""
      text.split("\n").each do |line|
        case line
        when /^\\section(.+)/
          section.push $1
        end

        case section[-1]
        when /.+abstract.+/
          abstract << line+"\n"
        when /.+概要.+/
          abstract << line+"\n"
        else
          content << line+"\n"
        end
      end
      abstract.delete_at(0)
      content.gsub!(/\\tableofcontents/){|text|
        tt="\n\\abstract\{\n#{abstract.join}\}\n\\tableofcontents"
      }
      return content
    end

    def listings_preamble
      str = <<"EOS"
\\documentclass[12pt,a4paper]{jsarticle}
\\usepackage[dvipdfmx]{graphicx}
\\usepackage[dvipdfmx]{color}
\\usepackage{listings}
% to use japanese correctly, install jlistings.
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
\\lstdefinestyle{customTex}{
  language={tex},
  numbers=none,
}
\\lstdefinestyle{customJava}{
  language={java},
  numbers=left,
}
EOS
    end

  end
end

