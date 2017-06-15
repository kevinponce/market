# frozen_string_literal: true

# handles cart and determining eligible discounts
class Cart
  attr_accessor :store, :items, :count

  def initialize(store)
    self.store = store
    self.items = []
    self.count = Hash.new(0)
  end

  def add!(product)
    # set to nil to make sure it recalculates eligible_discounts
    @eligible_discounts = nil
    count[product.code.to_sym] += 1
    items.push(product)
  end

  def empty!
    @eligible_discounts = nil
    self.count = Hash.new(0)
    self.items = []
  end

  def eligible_discounts
    @eligible_discounts ||= store.discounts.dup.inject({}) do |results, discount|
      if discount.eligible!(count.fetch(discount.buy_code.to_sym, 0))
        results[discount.discount_code.to_sym] = [] if results[discount.discount_code].nil?
        results[discount.discount_code.to_sym].push discount.dup
      end

      results
    end
  end
end
