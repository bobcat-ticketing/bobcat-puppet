require 'spec_helper'
describe 'bobcat' do
  context 'with default values for all parameters' do
    it { should contain_class('bobcat') }
  end
end
