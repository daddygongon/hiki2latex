#spec_chap1.rb
require 'spec_helper'

RSpec.describe 'hiki2latex command', type: :aruba do
  context 'version option', type: :version do
    before(:each) { run('hiki2latex v') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output("0.1.0") }
  end
end
