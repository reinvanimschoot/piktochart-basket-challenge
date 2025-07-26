require_relative "pricing_rule"

class DeliveryCostRule < PricingRule
  def initialize(delivery_cost:, max_subtotal:, min_subtotal:)
    @delivery_cost = delivery_cost
    @max_subtotal = max_subtotal
    @min_subtotal = min_subtotal
  end

  def applies?(basket)
    # Delivery is based on discounted subtotal

    discounted = basket.discounted_subtotal
    discounted >= @min_subtotal && discounted < @max_subtotal
  end

  def apply(basket)
    applies?(basket) ? @delivery_cost : 0.0
  end
end
