# frozen_string_literal: true

class VendingMachine
  attr_reader :product_storage, :coin_bank, :current_sum, :current_product_name

  def initialize(product_storage, coin_bank)
    @product_storage = product_storage
    @coin_bank = coin_bank
    @current_sum = 0.0
  end

  def run
    loop do
      select_product_operation
      payment_operation
      product_delivery_operation
      give_change_operation if overpayment > 0
      finish_operation

      if  product_storage.names.empty?
        puts 'Sorry or storage is empty. Machine turning off.'

        break
      end
    end
  end

  private

  def select_product_operation
    loop do
      puts 'Well come! Or machine can provide you our goods. For select product type it name:'

      product_names = product_storage.names
      product_names.each do |product_name|
        puts product_name
      end

      chosen_product_name = gets.strip!

      (@current_product_name = chosen_product_name) && break if product_names.include? chosen_product_name
    end

    puts "Your choose #{current_product_name}, it costs #{product_storage.price(current_product_name)}."
  end

  def payment_operation
    puts "Our machine takes such coins #{coin_bank.coin_names.join(', ')}. Please enter your coins:"

    loop do
      current_payment = gets.strip!

      if coin_bank.coin_names.include? current_payment
        @current_sum += coin_bank.add_coin(current_payment)
        product_price = product_storage.price(current_product_name)

        break if current_sum >= product_price

        puts "Your sum now #{current_sum}$, left #{product_price - current_sum}$"
      else
        puts "We can't get your coin: '#{current_payment}', please enter some of #{coin_bank.coin_names.join(', ')}"
      end
    end
  end

  def product_delivery_operation
    product_storage.give_out(current_product_name)
    puts "Please receive your #{current_product_name}"
  end

  def give_change_operation
    change_coin_sets = coin_bank.change_variants overpayment
    if change_coin_sets.empty?
      puts "Sorry, we can't give your change because of absent of coins"

      return
    end
    puts "Your rest is: #{overpayment}"
    variant_number = nil
    loop do
      puts 'Please select number of your change variant:'
      change_coin_sets.each_with_index do |change_coin_set, i|
        puts "#{i + 1}: " + format_coin_set(change_coin_set)
      end

      variant_number = gets.strip!

      break unless /^\d+$/.match(variant_number).nil? || variant_number.to_i > change_coin_sets.size

      puts "Your variant '#{variant_number}' is wrong, try again."
    end

    selected_set = change_coin_sets[variant_number.to_i - 1]
    coin_bank.give_out_change(selected_set)

    puts "Please receive your coins #{format_coin_set(selected_set)}"
  end

  def overpayment
    current_sum - product_storage.price(current_product_name)
  end

  def finish_operation
    puts 'Thank you!'
    @current_sum = 0.0
    @current_product_name = nil
  end

  private

  def format_coin_set(coin_set)
    coin_set.to_a.map { |set| "#{set[0]}x#{set[1]}"}.join(', ')
  end
end
