#!/usr/bin/env ruby

require './app_data/product_storage'
require './app_data/coin_bank'
require './app_data/vending_machine'

products = {
  'Chocolate' => {
    count: 1,
    price: 9.25
  },
  'Banana' => {
    count: 2,
    price: 3.50
  }
}

coins = {
  '25c' => {
    value: 0.25,
    count: 3
  },
  '50c' => {
    value: 0.5,
    count: 3
  },
  '1$' => {
    value: 1,
    count: 3
  },
  '2$' => {
    value: 2,
    count: 3
  },
  '5$' => {
    value: 5,
    count: 3
  },
}

VendingMachine.new(ProductStorage.new(products), CoinBank.new(coins)).run
