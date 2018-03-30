require 'spec_helper'
describe 'bobcat_embedded' do
  context 'with default values for all parameters' do
    it { should contain_class('bobcat_embedded') }
  end
end
