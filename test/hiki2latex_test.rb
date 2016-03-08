# -*- coding: utf-8 -*-
require 'test_helper'
require 'test/unit'

module Test::Unit

  class TestCase

    # included from "Ruby best practice" by Gregory Brown.
    def self.must(name, &block)
      p name
      test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
      defined = instance_method(test_name) rescue false
      raise "#{test_name} is already defined in #{self}" if defined
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end

  end
end

class  Hiki2latexTest < Test::Unit::TestCase
  must "it has a version number" do
    refute_nil ::Hiki2latex::VERSION
  end

  must "convert author" do
    result=HikiDoc.to_latex("!Author:西谷滋人")
    assert_equal result, "\\author{西谷滋人}\n\\date{}\n\\maketitle\n"
  end

  must "convert snake strings" do
    result=HikiDoc.to_latex("test_test")
    assert_equal result, "test\\_test\n\n"
  end

  must "no convert snake strings in $$" do
    result=HikiDoc.to_latex("$test_test_test$")
    assert_equal result, "$test_test_test$\n\n"
  end

  must "check for dmath with snake" do
    input=%q|{{dmath 'f_x_x'}}|
      result=HikiDoc.to_latex(input)
    assert_equal result, "\\begin{equation}\nf_x_x\n\\end{equation}"
  end

  must "check for math with snake" do
    input=%q|{{math 'f_x'}}|
      result=HikiDoc.to_latex(input)
    assert_equal result, "$f_x$"
  end

  must "check on url to verb with snake" do
    input="[[http://hoge_hoge_hoge]]"
    result=HikiDoc.to_latex(input)
    assert_equal result, "\\verb|http://hoge_hoge_hoge|\n\n"
  end

  must "check on list with snake and uri" do
    input="# underbar(_)がlatexでは全て引っかかる．対応済み \verb|hiki2latex_math|"
    result=HikiDoc.to_latex(input)
    expected ="\\begin{enumerate}\n\\item underbar(\\_)がlatexでは全て引っかかる．対応済み \verb|hiki2latex\\_math|\n\\end{enumerate}\n"
    assert_equal result, expected
  end

  must "check on table with snake and uri" do
    input="||under_score|| 8/11 || [[hiki2latex_math]]"
    result=HikiDoc.to_latex(input)
    expected = "\\begin{table}[htbp]\\begin{center}\n\\caption{}\n\\begin{tabular}{llll}\n\\hline\nunder\\_score  &8/11   &\\verb|hiki2latex_math|  \\\\ \\hline\n\\hline\n\\end{tabular}\n\\label{default}\n\\end{center}\\end{table}\n%for inserting separate lines, use \\hline, \\cline{2-3} etc.\n\n"
    assert_equal expected, result
  end
end

class Hiki2latexCommandTest < Test::Unit::TestCase
  def setup
    @command=::Hiki2latex::Command.new
#    assert_nil @command.execute
  end

  must "kill tableofcontents" do
    input="\\tableofcontents\n sample"
    result = @command.kill_head_tableofcontents(input)
    expected="\n sample"
    assert_equal expected,result
  end

  must "mod_abstract in engligh" do
    input="\\tableofcontents\n\\section{abstract} \n sample\n \\section{introduction}\n"
    result = @command.mod_abstract(input)
    result
    expected = "\n\\abstract{\n sample\n}\n\\tableofcontents\n \\section{introduction}\n"
#    assert_equal result, expected
  end

  must "mod_abstract 概要 in Japanese" do
    p input="\\tableofcontents\n\\section{概要} \n sample\n \\section{introduction}\n"
    result = @command.mod_abstract(input)
    p result
    expected = "\n\\abstract{\n sample\n}\n\\tableofcontents\n \\section{introduction}\n"
#    assert_equal result, expected
  end

end

class Hiki2latexProcTest < Test::Unit::TestCase
  must "check make_matrix" do
    print "\n------check make_matrix-----\n"
    p input=["||^ test1 || test2","|| test3 ","||>test4"]
    tmp= LatexOutput.new
    t_matrix,max_col = tmp.make_matrix(input)
    p t_matrix
    p max_col
  end

  must "check table last 4" do
    p result = HikiDoc.to_latex("||test||test2")
    expected = "\\begin{table}[htbp]\\begin{center}\n\\caption{}\n\\begin{tabular}{lll}\n\\hline\ntest  &test2  \\\\ \\hline\n\\hline\n\\end{tabular}\n\\label{default}\n\\end{center}\\end{table}\n%for inserting separate lines, use \\hline, \\cline{2-3} etc.\n\n"
    assert_equal expected,result
  end

end


