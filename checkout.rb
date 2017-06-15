# frozen_string_literal: true

require './cart.rb'
require './receipt.rb'

# class handles checkout
class Checkout
  attr_accessor :cart, :store

  def initialize(store)
    self.store = store
    self.cart = Cart.new(store)
  end

  def scan!(product_code)
    product = store.products[product_code.to_sym]

    if product.nil?
      false
    else
      cart.add!(product)

      true
    end
  end

  def print
    Receipt.new(cart).print
  end

  def empty_cart!
    cart.empty!
  end
end
