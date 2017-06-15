# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Proudct' do
  it { expect(Product.new('Chai', 'CH1', 3.11).name).to eq('Chai') }
  it { expect(Product.new('Chai', 'CH1', 3.11).code).to eq('CH1') }
  it { expect(Product.new('Chai', 'CH1', 3.11).price).to eq(3.11) }
end
