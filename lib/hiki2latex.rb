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
        opt.on('-p FILE', '--plain','make Plain latex document.') { |file| plain_doc(file) }
        opt.on('-b FILE', '--bare','make Bare latex document.') { |file| bare_doc(file) }
        opt.on('--head FILE', 'put headers of maketitle file.') { |file| @head=file }
        opt.on('--pre FILE', 'put preamble file.') { |file| @pre=file }
        opt.on('--post FILE', 'put post file.') { |file| @post=file }
        opt.on('--listings', 'use listings.sty for preformat with style.') {@listings=true }
      end
      command_parser.banner = "Usage: hiki2latex [options] FILE"
      command_parser.parse!(@argv)
      plain_doc(@argv[0]) if @argv[0]!=nil
      exit
    end

    # pre, post, listingsなどの拡張を処理
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
      return text
    end

    # convert section to abstract in the plain text
    def mod_abstract(text)
#      return text
      abstract,section = [],[]
      content = ""
      text.split("\n").each do |line|
        case line
        when /^\\section(.+)/
          section.push $1
        end
#        p section[-1]
        case section[-1]
        when /\{abstract\}/, /\{【abstract】\}/
          abstract << line+"\n"
        when /\{概要\}/, /\{【概要】\}/
          abstract << line+"\n"
        else
          content << line+"\n"
        end
      end
#      p abstract
      if abstract.size>1 then
        abstract.delete_at(0)
        content.gsub!(/\\tableofcontents/){|text|
          tt="\n\\abstract\{\n#{abstract.join}\}\n\\tableofcontents"
        }
      end
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
  basicstyle={\\ttfamily},
  identifierstyle={},
  commentstyle={\\color{red}},
  keywordstyle={\\bfseries\\color{cyan}},
  ndkeywordstyle={},
  stringstyle={\\color{blue}},
  frame={tb},
  breaklines=true,
  numbers=left,
  numberstyle={},
  stepnumber=1,
  numbersep=1zw,
  xrightmargin=0zw,
  xleftmargin=3zw,
  lineskip=0.5ex
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

