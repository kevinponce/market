# frozen_string_literal: true

# Examples
# BOGO -- Buy-One-Get-One-Free Special on Coffee. (Unlimited)
# coffee = Product.new('Chai', 'CH1', 3.11)
# Discount.new(name: 'BOGO', buy_qty: 1, buy_code: coffee.code, save_amount: coffee.price, discount_qty: 1, discount_code: coffee.code)

# APPL -- If you buy 3 or more bags of Apples, the price drops to $4.50.
# apples = Product.new('Apples', 'AP1', 6.00)
# Discount.new(name: 'APPL', buy_qty: 3, or_more: true, buy_code: apples.code, save_amount: 1.5, on_all: true, discount_code: apples.code)

# CHMK -- Purchase a box of Chai and get milk free. (Limit 1)
# coffee = Product.new('Chai', 'CH1', 3.11)
# milk = Product.new('Milk', 'MK1', 4.75)
# Discount.new(name: 'CHMK', buy_code: coffee.code, save_amount: 4.75, discount_code: milk.code, limit: 1)

# class discount
class Discount
  UNLIMITED = -1

  attr_accessor :name, :buy_qty, :buy_code, :save_amount, :discount_qty, :discount_code, :or_more, :limit, :on_all, :max_number_of_discounted_items, :discounted_count

  def initialize(name:, buy_qty: 0, buy_code:, save_amount:, discount_qty: 0, discount_code:, or_more: false, limit: nil, on_all: false)
    self.name = name
    self.buy_qty = buy_qty
    self.buy_code = buy_code
    self.save_amount = save_amount
    self.discount_qty = discount_qty
    self.discount_code = discount_code
    self.or_more = or_more
    self.limit = limit
    self.on_all = on_all

    # counters
    self.max_number_of_discounted_items = 0
    self.discounted_count = 0
  end

  # eligible! updates max_number_of_discounted_items and return bool
  def eligible!(item_count)
    return not_eligible! if item_count.zero? || item_count < buy_qty

    self.max_number_of_discounted_items = if limit
                                            (limit * discount_qty)
                                          elsif on_all
                                            UNLIMITED
                                          else
                                            item_count / number_of_items_per_discount * discount_qty
                                          end

    true
  end

  def applyable?(product)
    return false if discount_code != product.code
    return false if max_limit?
    return true if on_all

    discounted_count < max_number_of_discounted_items
  end

  def apply!(product)
    return false unless applyable?(product)

    self.discounted_count += 1
    true
  end

  private

  def max_limit?
    max_number_of_discounted_items != UNLIMITED && discounted_count >= max_number_of_discounted_items
  end

  def not_eligible!
    self.max_number_of_discounted_items = 0

    false
  end

  def number_of_items_per_discount
    if buy_code == discount_code
      (buy_qty + discount_qty)
    else
      buy_qty
    end
  end
end
