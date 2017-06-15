# frozen_string_literal: true

require_relative './product.rb'
require_relative './discount.rb'
require_relative './checkout.rb'

Dir['./discounts/*.rb'].each { |f| require f }

# class handles the store products and discounts
class Store
  attr_accessor :products, :discounts

  def initialize
    chai = Product.new('Chai', 'CH1', 3.11)
    apples = Product.new('Apples', 'AP1', 6.00)
    coffee = Product.new('Coffee', 'CF1', 11.23)
    milk = Product.new('Milk', 'MK1', 4.75)

    self.products = {
      CH1: chai,
      AP1: apples,
      CF1: coffee,
      MK1: milk
    }
    self.discounts = [
      BuyOneGetOneFree.new('BOGO', coffee),
      BuyXSaveY.new('APPL', 3, apples, 1.5),
      BuyXGetFreeY.new('CHMK', chai, milk, limit: 1)
    ]
  end
end
