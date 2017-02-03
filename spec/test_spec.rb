require 'spec_helper'

describe Hiki2latex do
  it 'should make bare latex file.' do
    assert("test",  "test\n\n")
  end
end
