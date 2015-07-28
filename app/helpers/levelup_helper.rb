module LevelupHelper
  def variant_is_in_stock?(variant)
    html = variant.in_stock? ? "" : "disabled"
    html.html_safe
  end

  def display_tax(tax_rate)
    tax_rate > 0 ? "" : 'hide'
  end
end
