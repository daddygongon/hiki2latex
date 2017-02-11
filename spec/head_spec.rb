# -*- coding: utf-8 -*-
require 'spec_helper'
require 'colorize'

describe Hiki2latex do
  it 'should return heads.' do
    input = <<EOS
!title:hoge
!author:hoge
!date:hoge
EOS
    expected = <<EOS
\\title{hoge}
\\author{hoge}
\\date{hoge}
\\maketitle
EOS
    print "-------hiki\n".green+input.blue
    print "-------latex\n".green+expected.blue
    assert(input, expected)
  end

  it 'should return pre_formted heads.' do
    input = <<EOS
<<<
!title:hoge
!author:hoge
!date:hoge
>>>
EOS
    expected = <<EOS
\\begin{quote}\\begin{verbatim}
!title:hoge
!author:hoge
!date:hoge
\\end{verbatim}\\end{quote}
EOS
    print "-------hiki\n".green+input.blue
    print "-------latex\n".green+expected.blue
    assert(input, expected)
  end

end
