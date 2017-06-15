# frozen_string_literal: true

require_relative '../discount.rb'

# class easily create buy x save y discount
class BuyXSaveY < Discount
  def initialize(name, num, product, save_amount)
    super(name: name, buy_qty: num, or_more: true, buy_code: product.code, save_amount: save_amount, on_all: true, discount_code: product.code)
  end
end
