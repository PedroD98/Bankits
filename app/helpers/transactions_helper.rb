module TransactionsHelper
  def transaction_value_color_class(transaction)
    return 'fee-text-color' if transaction.fee?
    return 'text-danger' if transaction.withdraw? || transaction.transfer_sent?  || transaction.manager_visit?
    'text-success' if transaction.deposit? || transaction.transfer_received?
  end

  def transaction_value_text_format(value)
    return value.format if value.positive?
    "(#{value.abs.format})"
  end

  def balance_text_color_class(balance)
    'text-danger' if balance < 0
  end
end
