# -*- coding: utf-8 -*-
require 'spec_helper'
require 'colorize'

describe Hiki2latex do
  it 'should convert table' do
    hiki =<<-EOS
||title0||title1||titile2
||^^head1-0||>head1-1
||head2-1||head2-2
||head3-1||head3-2
EOS
    latex =<<EOS
\\begin{table}[htbp]\\begin{center}
\\caption{}
\\begin{tabular}{llll}
\\hline
title0  &title1  &titile2  \\\\ \\hline
head1-0  &\\multicolumn{2}{l}{head1-1 }  \\\\
 &head2-1  &head2-2  \\\\
 &head3-1  &head3-2  \\\\
\\hline
\\end{tabular}
\\label{default}
\\end{center}\\end{table}
%for inserting separate lines, use \\hline, \\cline{2-3} etc.

EOS
    print "------hiki(input)-------\n".green+hiki.blue
    print "------latex(epected)-------\n".green+latex.blue
    assert(hiki,latex)
  end


end
