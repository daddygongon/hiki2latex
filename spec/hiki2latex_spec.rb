require 'spec_helper'

describe Hiki2latex do
  it 'should make emphasised sentence.' do
    assert("\'\'\'emphasis\'\'\'",  "\\textbf{emphasis}\n\n")
  end

  it 'should make bare latex file.' do
    assert("test",  "test\n\n")
  end

  it 'should correctly convert headers.' do
    assert("!head1",  "\\section{head1}\n")
    assert("!!head1",  "\\subsection{head1}\n")
    assert("!!!head1",  "\\subsubsection{head1}\n")
    assert("!!!!head1",  "\\paragraph{head1}\n")
  end

  it 'should convert no-num list' do
    assert("*item1","\\begin{itemize}\n\\item item1\n\\end{itemize}\n")
  end

  it 'should convert num list' do
    hiki ="#item1\n#item2\n"
    latex ="\\begin{enumerate}\n\\item item1\n\\item item2\n\\end{enumerate}\n"
    assert(hiki, latex)
  end

  it 'should convert pre-formatted text' do
    hiki =<<-EOS
<<< ruby
p "Hello."
>>>
EOS
    latex =<<EOS
\\begin{quote}\\begin{verbatim}
p \"Hello.\"
\\end{verbatim}\\end{quote}
EOS
    assert(hiki, latex)
  end

  it 'should convert table' do
    hiki =<<-EOS
||^head1||>head2
||head2||head3
EOS
    latex =<<EOS
\\begin{table}[htbp]\\begin{center}
\\caption{}
\\begin{tabular}{llll}
\\hline
head1  &\\multicolumn{2}{l}{head2 }  \\\\ \\hline
 &head2  &head3  \\\\
\\hline
\\end{tabular}
\\label{default}
\\end{center}\\end{table}
%for inserting separate lines, use \\hline, \\cline{2-3} etc.

EOS
    assert(hiki, latex)
  end

  it 'should convert quotation' do
    hiki ="\"\"test"
    latex ="\\begin{quotation}\ntest\n\n\\end{quotation}\n"
    assert(hiki, latex)
  end


end
