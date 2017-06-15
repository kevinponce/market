# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Checkout' do
  let(:store) { Store.new }
  let(:checkout) { Checkout.new(store) }

  describe 'scan!' do
    it { expect(checkout.scan!('CH1')).to be_truthy }
    it { expect(checkout.scan!('CH2')).to be_falsey }
  end
end
