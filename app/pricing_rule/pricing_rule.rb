class PricingRule
  def applies?(_basket)
    raise NotImplementedError
  end

  def apply
    raise NotImplementedError
  end
end
