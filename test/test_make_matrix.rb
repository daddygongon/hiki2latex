# -*- coding: utf-8 -*-
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

input=["||^ test1 || test2","|| test3 ","||>test4"]

t_matrix,max_col = make_matrix(input)
p t_matrix
p max_col
