# frozen_string_literal: true

# handles generating receipt
class Receipt
  attr_accessor :cart, :total, :billing_line_items

  BILLING_LINE_ITEM = Struct.new(:name, :amount)

  def initialize(cart)
    self.cart = cart
    self.total = 0.0
    self.billing_line_items = []
  end

  def build
    cart.items.each do |product|
      self.total += product.price

      apply_discounts(product)
    end

    billing_line_items.flatten!
    self
  end

  def print
    details = build

    puts 'Item      Price'
    puts '____      _____'
    details.billing_line_items.each do |bli|
      puts "#{bli.name}      #{bli.amount}"
    end
    puts '________________'
    puts "          #{details.total.to_f.round(2)}"
  end

  private

  def apply_discounts(product)
    discount_billing_line_items = []
    discounts = cart.eligible_discounts[product.code.to_sym]

    # http://www.rubydoc.info/gems/rubocop/0.43.0/RuboCop/Cop/Style/SafeNavigation
    discounts&.each do |discount|
      if discount.apply!(product)
        self.total -= discount.save_amount
        discount_billing_line_items.push(BILLING_LINE_ITEM.new(discount.name, discount.save_amount * -1.0))
      end
    end

    billing_line_items.push BILLING_LINE_ITEM.new(product.name, product.price)
    billing_line_items.push(discount_billing_line_items) unless discount_billing_line_items.empty?
  end
end
