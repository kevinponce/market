# frozen_string_literal: true

require_relative '../discount.rb'

# class easily create buy one get one free discount
class BuyOneGetOneFree < Discount
  def initialize(name, product)
    super(name: name, buy_qty: 1, buy_code: product.code, save_amount: product.price, discount_qty: 1, discount_code: product.code)
  end
end
