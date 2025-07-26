require_relative "pricing_rule"

class BuyGetPercentageRule < PricingRule
  def initialize(buy_quantity:, discount_percentage:, discounted_quantity:, product_code:)
    @buy_quantity = buy_quantity
    @discount_percentage = discount_percentage
    @discounted_quantity = discounted_quantity
    @product_code = product_code
  end

  def applies?(basket)
    basket.count(@product_code) >= (@buy_quantity + @discounted_quantity)
  end

  def apply(basket)
    count = basket.count(@product_code)

    return 0.0 if count < @buy_quantity + @discounted_quantity

    item_price = basket.price_for(@product_code)
    discount_per_item = item_price * (@discount_percentage / 100.0)

    group_size = @buy_quantity + @discounted_quantity
    discounted_items = (count / group_size) * @discounted_quantity

    -(discounted_items * discount_per_item)
  end
end
