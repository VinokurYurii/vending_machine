# frozen_string_literal: true

class ProductStorage
  attr_reader :products

  def initialize(products)
    @products = products
  end

  def price(name)
    products[name][:price]
  end

  def names
    products.select { |_k, v| v[:count] > 0 }.keys
  end

  def give_out(name)
    products[name][:count] -= 1
  end
end
