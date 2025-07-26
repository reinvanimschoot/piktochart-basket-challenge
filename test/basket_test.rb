require "minitest/autorun"

require_relative "../app/basket"
require_relative "../app/product"
require_relative "../app/pricing_rule/buy_get_percentage_rule"
require_relative "../app/pricing_rule/delivery_cost_rule"


describe "Basket with discounts + delivery tiers" do
  before do
    product_catalogue = {
      "R01" => Product.new("R01", "Red Widget", 32.95),
      "G01" => Product.new("G01", "Green Widget", 24.95),
      "B01" => Product.new("B01", "Blue Widget", 7.95)
    }

    discount_rules = [
      BuyGetPercentageRule.new(product_code: "R01", buy_quantity: 1, discounted_quantity: 1, discount_percentage: 50)
    ]

    delivery_cost_rules = [
      DeliveryCostRule.new(min_subtotal: 0, max_subtotal: 50, delivery_cost: 4.95),
      DeliveryCostRule.new(min_subtotal: 50, max_subtotal: 90, delivery_cost: 2.95),
      DeliveryCostRule.new(min_subtotal: 90, max_subtotal: Float::INFINITY, delivery_cost: 0.0)
    ]

    @basket = Basket.new(delivery_cost_rules:, discount_rules:, product_catalogue:)
  end

  it "applies lowest delivery tier" do
    @basket.add("B01")
    @basket.add("G01")

    _(@basket.total).must_equal 37.85
  end

  it "applies lowest delivery tier and buy X get percentage off rule" do
    @basket.add("R01")
    @basket.add("R01")

    _(@basket.total).must_equal 54.37
  end

  it "applies middle delivery tier" do
    @basket.add("R01")
    @basket.add("G01")

    _(@basket.total).must_equal 60.85
  end

  it "applies highest delivery tier and buy X get percentage off rule" do
    @basket.add("B01")
    @basket.add("B01")
    @basket.add("R01")
    @basket.add("R01")
    @basket.add("R01")

    _(@basket.total).must_equal 98.27
  end
end
