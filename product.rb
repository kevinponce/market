# frozen_string_literal: true

# class handles product
class Product
  attr_accessor :name, :code, :price, :discounts

  def initialize(name, code, price)
    self.name = name
    self.code = code
    self.price = price
    self.discounts = []
  end
end
