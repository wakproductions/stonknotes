module MoneyFormatter
  include ActiveSupport::NumberHelper

  def format_currency(amount)
    number_to_currency(amount, negative_format: '$(%n)')
  end
end
