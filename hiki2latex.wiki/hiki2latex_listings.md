# 【概要】
latexのlistingsスタイルを使って，source codeの色付き表示が可能に．

# 【hiki2latexの変更】
hikidoc2texで使われているのを参照して，

```ruby
  def block_preformatted(str, info)
    if (@listings==true and info!=nil) then
      style='customRuby' if info=='ruby'
      style='customCsh' if (info=='tcsh' or info=='csh')
      style='customTeX' if info=='tex'
      style='customJava' if info=='java'
      preformatted_with_style(str,style)
    else
      preformatted(text(str))
    end
  end

  def preformatted(str)
    @f.slice!(-1)
    @f << "\\begin{quote}\\begin{verbatim}\n"
    @f << str+"\n"
    @f << "\\end{verbatim}\\end{quote}\n"
  end

  def preformatted_with_style(str,style)
    @f.slice!(-1)
    @f << "\\begin{lstlisting}[style=#{style}]\n"
    @f << str+"\n"
    @f << "\\end{lstlisting}\n"
  end
```

opt周りは，

```ruby
        opt.on('--listings', 'use listings.sty for preformat with style.') {@listings=true }
```
としている．これをHikiDocへ渡す時は，

```ruby
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
      puts HikiDoc.to_latex(File.read(file),{:listings=>@listings})
      puts File.read(@post) if @post!=nil
      puts "\\end{document}"
    end
```
後ろのoptions={}の中にhashで登録している．texのstyleはlisting_preambleで打ち出すようにしている．

listingsの設定は以下の通り．

```tex
\documentclass[10pt,a4paper]{jsarticle}
\usepackage[dvipdfmx]{graphicx}
\usepackage[dvipdfmx]{color}
\usepackage{listings}
% to use japanese correctly, install jlistings.
\lstset{
  basicstyle={\small\ttfamily},
  identifierstyle={\small},
  commentstyle={\small\itshape\color{red}},
  keywordstyle={\small\bfseries\color{cyan}},
  ndkeywordstyle={\small},
  stringstyle={\small\color{blue}},
  frame={tb},
  breaklines=true,
  numbers=left,
  numberstyle={\scriptsize},
  stepnumber=1,
  numbersep=1zw,
  xrightmargin=0zw,
  xleftmargin=3zw,
  lineskip=-0.5ex
}
\lstdefinestyle{customCsh}{
  language={csh},
  numbers=none,
}
\lstdefinestyle{customRuby}{
  language={ruby},
  numbers=left,
}
\lstdefinestyle{customTex}{
  language={tex},
  numbers=none,
}
\lstdefinestyle{customJava}{
  language={java},
  numbers=left,
}
```

```
\begin{lstlisting}[style=customRuby]
  def block_preformatted(str, info)
    if (@listings==true and info!=nil) then
      style='customRuby' if info=='ruby'
      style='customCsh' if (info=='tcsh' or info=='csh')
      style='customTeX' if info=='tex'
...
\end{lstlisting}
```
