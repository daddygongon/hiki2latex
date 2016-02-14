# -*- coding: utf-8 -*-
# Copyright (c) 2015 Shigeto R. Nishitani
# All rights reserved.
#
require 'hikidoc'

class HikiDoc
  def HikiDoc.to_latex(src, options = {})
    new(LatexOutput.new(), options).compile(src)
  end
end


class LatexOutput
  def initialize(suffix = "")
    @suffix = suffix
#    @f = nil
    reset
  end

  def reset
#    @f = StringIO.new
    @f, @head, @caption, @table ="","","",""
  end

  def finish
    if @head != "" then
      @head << "\\date\{\}\n" if !@head.include?("date")
      @head << "\\maketitle\n"
      return @head+@f
    else
      return @f
    end
  end

  def container(_for=nil)
    case _for
    when :paragraph
      []
    else
      ""
    end
  end

  #
  # Procedures
  #

  def headline(level, title)
    title = escape_snake_names(title)
    tmp=title.split(/:/)
    if tmp.size!=1 then
      case tmp[0]
      when 'title','author','date'
        @head << "\\#{tmp[0]}\{#{tmp[1]}\}\n"
      when 'caption'
        @caption << "#{tmp[1]}"
      when 'reference'
        @f << "\\section*\{#{tmp[1]}\}\n"
      else
        @f << "\\#{tmp[0]}\{#{tmp[1]}\}\n"
      end
      return
    end
    case level
    when 1
      @f << "\\section\{#{title}\}\n"
    when 2
      @f << "\\subsection\{#{title}\}\n"
    when 3
      @f << "\\subsubsection\{#{title}\}\n"
    else
      @f << "\\paragraph\{#{title}\}\n"
    end
  end

  def block_plugin(str)
    tmp=[]
    if ( /(\w+)\((.+)\)/ =~ str ) or ( /(\w+).\'(.+)\'/ =~str ) or (/(\w+)/ =~ str)
      tmp = [$1,$2]
    end

    case tmp[0]
    when 'toc'
      @f << "\\tableofcontents\n"
    when 'attach_anchor'
      @f << "\\input\{#{tmp[1]}\}\n"
    when 'attach_view'
      @f << "\\begin{figure}[htbp]\\begin{center}\n"
      @f << "\\includegraphics[width=6cm]\{./#{tmp[1]}\}\n"
      @f << "\\caption\{"+@caption+"\}\n"
      @f << "\\label\{default\}\\end\{center\}\\end\{figure\}\n"
      @caption = "" #reset caption
    when 'dmath'
      @f << "\\begin{equation}\n#{tmp[1]}\n\\end{equation}"
    when 'math'
      @f << "\$#{tmp[1]}\$"
    else
      @f << "Don\'t know \\verb|{{#{str}}}|\n"
    end
 end

  def text(str)
    str
  end

  # inline means only in table??
  def inline_plugin(src)
    if ( /(\w+)\s+\'(.+)\'/ =~src ) or ( /(\w+)\((.+)\)/ =~ src ) or (/(\w+)/ =~ src)
      tmp = [$1,$2]
    end
    case tmp[0]
    when 'dmath'
       "\\begin{equation}\n#{tmp[1]}\n\\end{equation}"
    when 'math'
       "\$#{tmp[1]}\$"
#    when 'attach_view'
#       "\n\\includegraphics[scale=0.3]\{./#{tmp[1]}\}\n"
    else
       %Q(\\verb\|{{#{src}}}\|)
    end
  end

  def escape_html(text)
    text
  end

  def unescape_html(text)
    text
  end

  def escape_htm_param(str)
    str
  end

  def escape_snake_names(str)
    str.gsub!(/_/,"\\_")
    patterns = [/\$(.+?)\$/ , /\\verb\|(.+?)\|/, /equation(.+?)equation/m ]
    patterns.each{|pattern|
      str.gsub!(/\\_/,"_")    if str.match(pattern)
    }
    str
  end

  def paragraph(lines)
    lines.each{|line| line = escape_snake_names(line) }
    @f << "#{lines.join("\n")}\n\n"
  end
  def blockquote_open()
  end
  def blockquote_close()
  end

  def del(item)
    # use ulem or jumoline
  end

  def em(item)
    @f << "\\textbf\{#{item}\}"
  end

  def strong(item)
    @f << "\\textbf\{#{item}\}"
  end

  def block_preformatted(str, info)
    preformatted(text(str))
  end
  def preformatted(str)
    @f.slice!(-1)
    @f << "\\begin{quote}\\begin{verbatim}\n"
    @f << str+"\n"
    @f << "\\end{verbatim}\\end{quote}\n"
  end

  def list_begin
  end

  def list_end
  end

  def list_open(type)
    @f.slice!(-1) #こいつがわからん．\begin{item..}の前に改行が入るから．．．なぜ？
    #二重のitemizeでおかしくなるが，へんなところで改行は入らないので．
    case type
    when 'ul' then
      @f << "\\begin{itemize}\n"
    when 'ol' then
      @f << "\\begin{enumerate}\n"
    end
  end

  def list_close(type)
    case type
    when 'ul' then
      @f <<  "\\end{itemize}\n"
    when 'ol' then
      @f << "\\end{enumerate}\n"
    end
  end

  def listitem_open
    @f << "\\item "
  end

  def listitem_close
    #      @f << "\n" #closeでやるとうまくいかないときあり．listitemに改行を付け足した．
  end

  def listitem(item)
    @f << escape_snake_names(item) << "\n"
  end

  def dlist_open
    @f.slice!(-1)
    @f << "\\begin{description}\n"
  end

  def dlist_close
    @f << "\\end{description}\n"
  end

  def dlist_item(dt, dd)
    case
    when dd.empty?
      @f << "\\item[#{dt}]"
    when dt.empty?
      @f << "\\item #{dd}"
    else
      @f << "\\item[#{dt}] #{dd}\n"
    end
  end

  def table_open
    @table = ""
  end

  def table_close
    @f << make_table
  end

  DT_ALIGN='l'
  # tableから連結作用素に対応したmatrixを作る
  # input:lineごとに分割されたcont
  # output:matrixと最長列数
  def make_matrix(cont)
    t_matrix=[]
    cont.each{|line|
      tmp=line.split('||')
      tmp.slice!(0)
      tmp.slice!(-1) if tmp.slice(-1)=="\n"
      tmp.each_with_index{|ele,i| tmp[i] = ele.match(/\s*(.+)/)[1]}
      t_matrix << tmp
    }
    t_matrix.each_with_index{|line,i|
      line.each_with_index{|ele,j|
        if ele=~/\^+/ then
          t_matrix[i][j]=""
          rs=$&.size
          c_rs=rs/2
          rs.times{|k| t_matrix[i+k+1].insert(j,"")}
          t_matrix[i+c_rs][j]=$'
        end
      }
    }
    max_col=0
    t_matrix.each_with_index{|line,i|
      n_col=line.size
      line.each_with_index{|ele,j|
        if ele=~/>+/ then
          cs=$&.size
          t_matrix[i][j]= "\\multicolumn{#{cs+1}}{#{DT_ALIGN}}{#{$'}} "
          n_col+=cs
        end
      }
      max_col = n_col if n_col>max_col
    }
    return t_matrix,max_col
  end

  # tableを整形する
  def make_table
    cont,max_col = make_matrix(@table.split("\n"))

    position = "{"
    max_col.times{ position << DT_ALIGN}
    position << "}"
    buf = "\\begin{table}[htbp]\\begin{center}\n"
    buf << "\\caption{#{@caption}}\n"
    buf << "\\begin{tabular}#{position}\n\\hline\n"

    cont.each_with_index{|line,i|
      line.each{|ele|
        buf << "#{ele} &"
      }
      buf.slice!(-1)
      buf << ((i==0)? "\\\\ \\hline\n" : "\\\\\n")
    }
    buf << "\\hline\n\\end{tabular}\n"
    buf << "\\label{default}\n\\end{center}\\end{table}\n"
    @caption = ""
    buf << "%for inserting separate lines, use \\hline, \\cline{2-3} etc.\n\n"
    return buf
  end

  def table_record_open
    @table << "\|\| "
  end

  def table_record_close
    @table << " \n"
  end

  def table_head(item, rs, cs)
    @table << item.chomp+" \|\| "
  end

  def table_data(item, rs, cs)
    @table << "#{tdattr(rs,cs)}#{item.chomp} \|\| "
  end

  def tdattr(rs, cs)
    buf = ""
    (rs.to_i-1).times{ buf << "^"}
    (cs.to_i-1).times{ buf << ">"}
    return buf
  end
  private :tdattr


  def hyperlink(uri, title)
    if uri==title then
      %Q(\\verb\|#{uri}\|)
    else
      %Q(\\verb\|#{title}(#{uri})\|)
    end
  end

end

if __FILE__ == $0
  #  puts HikiDoc.to_html(ARGF.read(nil))
  puts "\\documentclass[12pt,a4paper]{jsarticle}"
  puts "\\usepackage[dvipdfmx]{graphicx}"
  puts "\\begin{document}"
  puts HikiDoc.to_latex(ARGF.read(nil))
  puts "\\end{document}"
end
