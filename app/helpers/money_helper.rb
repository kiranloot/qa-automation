module MoneyHelper
  def money_format(amount)
    '$%.2f' % amount
  end
end
