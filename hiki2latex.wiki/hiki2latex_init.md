# 【変更作業の手順】
- hikiをhtmlに変換するhikidoc.rbに加えていく形で変更
- hikidocについて調べよ(澄田の宿題）

```ruby
bob% diff hikidoc.rb master-hikidoc/lib/hikidoc.rb 
39d38
< require './hiki2latex.rb'
58,61d56
<   def HikiDoc.to_latex(src, options = {})
<     new(LatexOutput.new(""), options).compile(src)
<   end
< 
916,917c911
< #  puts HikiDoc.to_html(ARGF.read(nil))
<   puts HikiDoc.to_latex(ARGF.read(nil))
---
>   puts HikiDoc.to_html(ARGF.read(nil))
```

- hiki2latex.rbに変更を加えていく．
# 【設計】
## 【maketitleの挿入】
latex formatに仕込む際にテキストの順序が前後するコマンドが幾つかある．
\\maketitleの前に置かれた，
- title
- author
である．これらはheadersとしてtext部と別に返すことも可能である．
具体的には，

| to_html | *fを返す|
|:----|:----|
| to_latex | *fと*headを返す．|

なおto_htmlとの互換性を維持するため*headを後に返すようにしている．

しかし，この部分は，to_htmlとの整合性を考えるとto_latexで処理してしまった方がよい．
そこで，

```ruby
def finish
  @f.string
end
```
となっているのを，

```ruby
  def finish
    if @head != "" then
      @head << "\\maketitle\n"
      return @head+@f
    else
      return @f
    end
  end
```
とした．

# 【sample】
- ![](Jihou15)

# 【pdfの貼り込み】
pdfpagesを使おうとすると

```
/usr/local/texlive/2015/texmf-dist/tex/latex/pdfpages/pdfpages.sty:70: LaTeX Er
ror: Missing \begin{document}.

See the LaTeX manual or LaTeX Companion for explanation.
Type  H <return>  for immediate help.
 ...                                              
                                                  
l.70 \input{pp\AM@driver.def}
```
というエラーが出る．この解決法がわからず，incudegraphicsで対応．

```
¥documentclass{jsarticle}
¥usepackage[dvipdfmx,hiresbb]{graphicx}
¥begin{document}
¥includegraphics[width=5cm]{sample.pdf}
¥end{document}

の4行目を
¥includegraphics[page=3,width=5cm]{sample.pdf}
とすれば、

普通に３ページ目の画像を使うことができました。

美文書5版のCD-ROMから普通にインストールした TeXShopの環境です。

つまり、何も（といっても、同書 P114 にあるように、
 --shell--escape--commands=extractbb 
をTeXShop環境設定の「内部設定」タブ　pdfTex のLatexのオプションとして付け加えています。）特別なことをせずに、ページ指定をするだけで、できてしまいました。

次の、美文書の版には、ページ設定についても解説していただくといいかも知れません。＞奥村先生お願いします。
```
