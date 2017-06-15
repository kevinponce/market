# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Discount' do
  let(:product) { Product.new('Chai', 'CH1', 3.11) }
  let(:product2) { Product.new('Milk', 'MK1', 5.30) }

  describe 'init' do
    let(:discount) { BuyOneGetOneFree.new('BOGO', product) }

    it { expect(discount.name).to eq('BOGO') }
    it { expect(discount.buy_qty).to eq(1) }
    it { expect(discount.buy_code).to eq('CH1') }
    it { expect(discount.save_amount).to eq(3.11) }
    it { expect(discount.discount_qty).to eq(1) }
    it { expect(discount.discount_code).to eq('CH1') }
  end

  describe 'eligible!' do
    describe 'BOGO' do
      let(:discount) { BuyOneGetOneFree.new('BOGO', product) }

      it { expect(discount.eligible!(0)).to be_falsey }
      it { expect(discount.eligible!(1)).to be_truthy }
      it { expect(discount.eligible!(2)).to be_truthy }

      it 'max_number_of_discounted_items is 1' do
        discount.eligible!(2)

        expect(discount.max_number_of_discounted_items).to eq(1)
      end
    end

    describe 'BuyXSaveY' do
      let(:discount) { BuyXSaveY.new('BuyXSaveY', 3, product, 1.10) }

      it { expect(discount.eligible!(0)).to be_falsey }
      it { expect(discount.eligible!(1)).to be_falsey }
      it { expect(discount.eligible!(2)).to be_falsey }
      it { expect(discount.eligible!(3)).to be_truthy }

      it 'max_number_of_discounted_items is unlimited' do
        discount.eligible!(3)

        expect(discount.max_number_of_discounted_items).to eq(Discount::UNLIMITED)
      end
    end

    describe 'BuyXGetFreeY' do
      let(:discount) { BuyXGetFreeY.new('BuyXGetFreeY', product, product2, limit: 2) }

      it { expect(discount.eligible!(0)).to be_falsey }
      it { expect(discount.eligible!(1)).to be_truthy }

      it 'max_number_of_discounted_items is 2' do
        discount.eligible!(3)

        expect(discount.max_number_of_discounted_items).to eq(2)
      end
    end
  end

  describe 'applyable?' do
    describe 'BOGO' do
      let(:discount) { BuyOneGetOneFree.new('BOGO', product) }

      it 'max_number_of_discounted_items: 0' do
        discount.max_number_of_discounted_items = 0
        expect(discount.applyable?(product)).to be_falsey
      end

      it 'max_number_of_discounted_items: 1' do
        discount.max_number_of_discounted_items = 1
        expect(discount.applyable?(product)).to be_truthy
      end
    end

    describe 'BuyXSaveY' do
      let(:discount) { BuyXSaveY.new('BuyXSaveY', 3, product, 1.10) }

      it 'max_number_of_discounted_items: 0' do
        discount.max_number_of_discounted_items = 0
        expect(discount.applyable?(product)).to be_falsey
      end

      it 'max_number_of_discounted_items: 1' do
        discount.max_number_of_discounted_items = 1
        expect(discount.applyable?(product)).to be_truthy
      end
    end

    # applyable? assumes it was already eligible?
    describe 'BuyXGetFreeY' do
      let(:discount) { BuyXGetFreeY.new('BuyXGetFreeY', product, product2) }

      it 'max_number_of_discounted_items: 1' do
        discount.max_number_of_discounted_items = 0
        expect(discount.applyable?(product)).to be_falsey
      end

      it 'max_number_of_discounted_items: 1' do
        discount.max_number_of_discounted_items = 1
        expect(discount.applyable?(product2)).to be_truthy
      end
    end
  end

  describe 'apply!' do
    describe 'BOGO' do
      let(:discount) { BuyOneGetOneFree.new('BOGO', product) }

      it 'is not applyable' do
        allow(discount).to receive(:applyable?).with(product).and_return(false)

        expect(discount.apply!(product)).to be_falsey
      end

      it 'is applyable' do
        allow(discount).to receive(:applyable?).with(product).and_return(true)
        expect(discount.apply!(product)).to be_truthy
      end
    end
  end
end
