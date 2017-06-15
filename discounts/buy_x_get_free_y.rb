# frozen_string_literal: true

require_relative '../discount.rb'

# class easily create buy x get free y discount
class BuyXGetFreeY < Discount
  def initialize(name, product1, product2, options = {})
    buy_qty = options.fetch(:buy_qty, 1)
    discount_qty = options.fetch(:discount_qty, 1)
    limit = options.fetch(:limit, nil)

    super(name: name, buy_qty: buy_qty, or_more: false, buy_code: product1.code, save_amount: product2.price, discount_qty: discount_qty, discount_code: product2.code, limit: limit)
  end
end
