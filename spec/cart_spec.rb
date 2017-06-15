# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Cart' do
  let(:store) { Store.new }
  let(:cart) { Cart.new(store) }
  let(:product) { Product.new('Example', 'EX1', 3.41) }

  describe 'add!' do
    before(:each) { cart.add!(product) }

    it { expect(cart.items.length).to eq(1) }
    it { expect(cart.items.last.name).to eq(product.name) }
    it { expect(cart.count[:EX1]).to eq(1) }
  end

  describe 'empty!' do
    before(:each) do
      cart.add!(product)
      cart.empty!
    end

    it { expect(cart.items.length).to eq(0) }
    it { expect(cart.items.last).to be_nil }
    it { expect(cart.count[:EX1]).to eq(0) }
  end

  describe 'eligible_discounts' do
    describe '{ CH1: 4, AP1: 1, CF1: 2 }' do
      before(:each) { cart.count = { CH1: 4, AP1: 1, CF1: 2 } }

      it { expect(cart.send(:eligible_discounts).include?(:CH1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:MK1)).to be_truthy }
      it { expect(cart.send(:eligible_discounts).include?(:AP1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:CF1)).to be_truthy }
    end

    describe '{ CH1: 2, AP1: 1, CF1: 3 }' do
      before(:each) { cart.count = { CH1: 2, AP1: 2, CF1: 3 } }
      it { expect(cart.send(:eligible_discounts).include?(:CH1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:MK1)).to be_truthy }
      it { expect(cart.send(:eligible_discounts).include?(:AP1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:CF1)).to be_truthy }
    end

    describe '{ CH1: 0, AP1: 1, CF1: 1 }' do
      before(:each) { cart.count = { CH1: 0, AP1: 3, CF1: 1 } }
      it { expect(cart.send(:eligible_discounts).include?(:CH1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:MK1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:AP1)).to be_truthy }
      it { expect(cart.send(:eligible_discounts).include?(:CF1)).to be_truthy }
    end

    describe '{ CH1: 0, AP1: 1, CF1: 0 }' do
      before(:each) { cart.count = { CH1: 1, AP1: 4, CF1: 0 } }

      it { expect(cart.send(:eligible_discounts).include?(:CH1)).to be_falsey }
      it { expect(cart.send(:eligible_discounts).include?(:MK1)).to be_truthy }
      it { expect(cart.send(:eligible_discounts).include?(:AP1)).to be_truthy }
      it { expect(cart.send(:eligible_discounts).include?(:CF1)).to be_falsey }
    end
  end
end
