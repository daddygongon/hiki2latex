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
    p input="# underbar(_)がlatexでは全て引っかかる．対応済み \verb|hiki2latex_math|"
    result=HikiDoc.to_latex(input)
    p result
#    assert_equal result, "\\verb|http://hoge_hoge_hoge|\n\n"
  end

  must "check on table with snake and uri" do
    p input="||under_score|| 8/11 || [[hiki2latex_math]]"
    result=HikiDoc.to_latex(input)
    p result
#    assert_equal result, "\\verb|http://hoge_hoge_hoge|\n\n"
  end


end
