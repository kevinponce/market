# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'rspec'
require 'simplecov'

require './store'
require './discount'
require './product'
require './cart'
require './receipt'

Dir['./discounts/*.rb'].each { |f| require f }

SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
