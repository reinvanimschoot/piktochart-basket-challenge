require "bigdecimal"

class Basket
  def initialize(product_catalogue:, delivery_cost_rules:, discount_rules:)
    @product_catalogue = product_catalogue
    @delivery_cost_rules = delivery_cost_rules
    @discount_rules = discount_rules

    @items = []
  end

  def add(product_code)
    product = @product_catalogue[product_code]
    raise ArgumentError, "Product not in catalogue: #{product_code}" unless product

    @items << product
  end

  def total
    BigDecimal(discounted_subtotal + delivery_cost, 10).round(2, BigDecimal::ROUND_DOWN).to_f
  end

  def discounted_subtotal
    BigDecimal(subtotal + discount_total, 10).round(2, BigDecimal::ROUND_DOWN).to_f
  end

  # Helpers for delivery and discount rules

  def count(product_code)
    @items.count { |item| item.code == product_code }
  end

  def price_for(product_code)
    product = @product_catalogue[product_code]
    raise ArgumentError, "Product not in catalogue: #{product_code}" unless product

    product.price
  end

  private

  def subtotal
    @items.sum(&:price)
  end

  def delivery_cost
    @delivery_cost_rules.sum { |r| r.apply(self) }
  end

  def discount_total
    @discount_rules.sum { |r| r.apply(self) }
  end
end
