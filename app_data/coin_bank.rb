# frozen_string_literal: true

class CoinBank
  attr_reader :coins

  def initialize(coins)
    @coins = coins
  end

  def change_coins(overpayment)
    coins.select { |_k, v| v[:value] <= overpayment && v[:count] > 0 }
  end

  def change_variants(overpayment)
    coin_sets = coin_sets_for_change(overpayment)
    set_to_arr_of_hashes(coin_sets)
  end

  def coin_names
    coins.keys
  end

  def add_coin(name)
    coins[name][:count] += 1
    coins[name][:value]
  end

  def give_out_change(coin_set)
    coin_set.each do |name, count|
      coins[name][:count] -= count
    end
  end

  private

  def set_to_arr_of_hashes(coin_set)
    coin_set.map do |coin_set|
      coin_set.reduce({}) do |result, coin_name|
        if result[coin_name].nil?
          result.merge(coin_name => 1)
        else
          result.tap do |r|
            r[coin_name] += 1
          end
        end
      end
    end
  end

  def coin_sets_for_change(rest, coin = nil)
    variants = []
    change_coins = coins.select { |_k, v| v[:value] <= rest && v[:count] > 0 }

    return [] if change_coins.empty?

    if coin.nil?
      change_coins.values.sort { |a, b| b[:value] <=> a[:value] }.each do |coin|
        variants += coin_sets_for_change(rest, coin)
      end
    else
      max_coin_times = rest / coin[:value] < coin[:count] ? (rest / coin[:value]).floor.to_i : coin[:count]

      max_coin_times.times do |i|
        coin_times = max_coin_times - i
        base_variant = []
        coin_times.times do
          base_variant << coins.key(coin)
        end

        new_rest = rest - coin[:value] * coin_times

        if coin_times * coin[:value] == rest
          variants << base_variant
        else
          new_change_coins = coins.select { |_k, v| v[:value] <= new_rest && v[:count] > 0 && v[:value] < coin[:value] }
          new_change_coins.values.sort { |a, b| b[:value] <=> a[:value] }.each do |lower_coin|
            lower_variants = coin_sets_for_change(new_rest, lower_coin)
            lower_variants.each do |lower_variant|
              variants << base_variant + lower_variant
            end
          end
        end
      end
    end

    variants
  end
end
