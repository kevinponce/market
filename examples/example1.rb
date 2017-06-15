# frozen_string_literal: true

require_relative '../store.rb'
require_relative '../checkout.rb'

store = Store.new
checkout = Checkout.new(store)

checkout.scan!('CH1')
checkout.scan!(:AP1)
checkout.scan!(:AP1)
checkout.scan!(:AP1)
checkout.scan!(:MK1)

checkout.print
