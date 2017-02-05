# -*- coding: utf-8 -*-
require 'spec_helper'

describe Hiki2latex do
  it 'should make emphasised sentence.' do
    assert("\'\'\'emphasis\'\'\'",  "\\textbf{emphasis}\n\n")
  end

  it 'should return pre_formted even heads.' do
    input = <<EOS
<<<
!title:hoge
!author:hoge
!date:hoge
>>>
EOS
    expected = "\\begin{quote}\\begin{verbatim}\n!title:hoge\n!author:hoge\n!date:hoge\n\\end{verbatim}\\end{quote}\n"

    print expected
    assert(input, expected)
  end


end
