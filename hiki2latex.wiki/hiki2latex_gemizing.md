
# 【概要】
hikiフォーマットの記述をlatexフォーマットに変換する
# 【使用法】
gem化して配布可能とした．したがって，installがちゃんとできていれば，
:command lineから:
```tcsh
bob% hiki2latex Shunkuntype_manual > tmp.tex
```
:libraryとして:
```ruby
require 'hiki2latex'

puts HikiDoc.to_latex(File.read(ARGV[0]))
```
```tcsh
bob% ruby trans.rb ./Shunkuntype_manual > tmp.tex
```
などとして利用できる．

# 【help】

```tcsh
bob% hiki2latex
Usage: hiki2latex [options]
    -v, --version                    show program Version.
    -l, --level VALUE                set Level for output section.
    -p, --plain FILE                 make Plain document.
    -b, --bare FILE                  make Bare document.
        --head FILE                  put headers of maketitle file.
        --pre FILE                   put preamble file.
        --post FILE                  put post file.
```

# 【詳細使用例(-p)】
以下のようなSampleDoc
```hiki
bob% cat SampleDoc 
!title
contents
*list1
*list2
!!title2
```
を
```tex
bob% hiki2latex -p SampleDoc 
\documentclass[12pt,a4paper]{jsarticle}
\usepackage[dvipdfmx]{graphicx}
\begin{document}
\section{title}
contents
\begin{itemize}
\item list1
\item list2
\end{itemize}
\subsection{title2}
\end{document}
```
となる．

# 【詳細使用例(-b)】
上記
```tex
 \begin{document}
 ...
 \end{document}
```
の中身だけを生成．いくつものtex filesをincludeしている場合の個別ファイル作成に便利．

この際，'-l 2'として付録のsectionとかを調整する．

# 【詳細使用例( --head,  --pre,  --post】
formatを標準と違うものにするために，pre,head,postがある．詳しくはsampleを見よ．
していしていく順番はないはずだけど，-p SampleDocだけは順番があるのかな．
あと，erbみたいにして使ったほうがいいかも．
```tcsh
 bob% hiki2latex --pre preamble.tex --head head.tex --post post.tex -p SampleDoc 
```
```tex
%preamble.tex
\documentclass[12pt,a4paper]{jsarticle}
\usepackage[dvipdfmx]{graphicx}
\pagestyle{empty}
```
```tex
 \begin{document}
```
```tex
%head.tex
\author{関西学院大学・理工学部・西谷滋人}
\title{touch typing習得環境shunkuntype}
\date{\today}
\maketitle
```
```tex
 \section{title}
 contents
 \begin{itemize}
 \item list1
 \item list2
 \end{itemize}
 \subsection{title2}
```
```tex
%post.tex
\pagebreak
\appendix
\section{マニュアル}
\input{shunkuntype_manual}
\pagebreak
\section{gem化メモ}
\input{shunkuntype_gemizing}
\pagebreak
\section{初期版のコード解説}
\input{shunkuntype_coding}
```
```tex
 \end{document}
```
# 【lib/hiki2latex.rb】
```ruby
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
```

## kill_head_line
kill_head_lineで付録(bare_text)にtocが含まれている場合は削除．
```ruby
    def kill_head_tableofcontents(text)
      text.gsub!(/^\\tableofcontents/,'')
    end
```

## mod_abstract
mod_abstractで\verb|\section{abstract}|で書かれた内容をabstract環境へ移行する．一行づつの処理は有限状態マシン的に処理するのがいいらしい(Ruby Best Practice, p.112)．一旦contentとabstractを分けて，その後，tableofcontentの前にabstractを挿入している．delete_at(0)は一行目に\verb|\section{【abstract】}|が存在するため．
```ruby
# convert section to abstract
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
```
