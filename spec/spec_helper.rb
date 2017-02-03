$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hiki2latex'

def assert(hiki, latex)
  converted = HikiDoc.to_latex(hiki)
  expect(converted).to eq(latex)
end
