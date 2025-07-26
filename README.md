# Piktochart Basket Challenge

## Running the tests

Tests use Minitest (spec style).

To run all tests:

```rb
ruby -Itest test/basket_test.rb
```

## Assumptions

- In the future, more delivery and pricing rules should and will be added.
- Delivery costs should be calculated after discount rules have been applied.
- Money is truncated at 2 decimals.

## Thoughts

My primary concern was that both delivery rules and discount rules should not be hard coded or too tightly coupled. It could have been easy to implement the "Buy one red widget, get the second at half price" rule directly in the `Basket` class but that would mean it would be very difficult to adjust or remove without altering the code. 

It would also become difficult for non-programmers to add or remove delivery and discount rules at will, which is, I would imagine, an important design requirement when working in e-commerce.

Hence, I created a unified `PricingRule` class that serves as an abstract base class and requires two methods to be implemented:
- `applies?(basket)`
- `apply(basket)`

I then proceeded to create two subclasses,
- `DeliveryCostRule` that implements the delivery cost calculations.
- `BuyGetPercentageRule` that allows a percentage off when a certain amount of items has been added.

This system has the following three important advantages:

It is very extensible to add new rules or remove them. For example, instead of having a percentage off when an item is added, you might want to add the rule "Buy one, get one free".

This is very simple using this API. You just add a class called `BuyGetFree` and makes sure it implements `applies?` and `apply`.

Secondly, it also allows for low-code solutions where these rules can be defined as JSON or YAML. This is perfect for when an e-commerce is handed off to the actual store owners.

Thirdly, the rules don't need to know very, very little of the product and basket implementations and are thus very loosely coupled. The rules just use a very limited set of helpers that is defined on the `Basket` class.

---

I then made sure that the total discount was calculated before the actual delivery costs. That way buyers don't receive lower shipping while also paying lower prices.

---

I then made sure that all the pieces worked together as they should by setting up a simple and short test suite using `MiniSpec`.

---
In general, I kept my code as loosely coupled and as extensible as possible. No class has any hard dependency on any other class or knows of any other class' internals.

At the same time, the code is very extensible. Rules can be easily added or removed, even as JSON or YAML if this should be desired.

## What could be improved

- Make more strict use of `BigDecimal` for currency calculations.
- Unify a `Basket`'s `discount_rules` and `delivery_cost_rules` in one `pricing_rules` parameter and type check inside of the class. Although, I suppose this is more of a stylistic choice.