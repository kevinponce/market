# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Receipt' do
  let(:store) { Store.new }
  let(:cart) { Cart.new(store) }

  describe 'build' do
    it 'buy CH1, AP1, AP1, AP1, MK1 for 16.61' do
      cart.add!(store.products[:CH1])
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:MK1])

      expect(Receipt.new(cart).build.total).to eq(16.61)
    end

    it 'buy CH1, AP1, CF1, MK1 for 20.34' do
      cart.add!(store.products[:CH1])
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:CF1])
      cart.add!(store.products[:MK1])

      expect(Receipt.new(cart).build.total).to eq(20.34)
    end

    it 'buy MK1, AP1 for 10.75' do
      cart.add!(store.products[:MK1])
      cart.add!(store.products[:AP1])

      expect(Receipt.new(cart).build.total).to eq(10.75)
    end

    it 'buy 1 CF1 get 1 free' do
      cart.add!(store.products[:CF1])
      cart.add!(store.products[:CF1])

      expect(Receipt.new(cart).build.total).to eq(11.23)
    end

    it 'buy AP1, AP1, CH1, AP1 for $16.61' do
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:AP1])
      cart.add!(store.products[:CH1])
      cart.add!(store.products[:AP1])

      expect(Receipt.new(cart).build.total).to eq(16.61)
    end
  end
end
