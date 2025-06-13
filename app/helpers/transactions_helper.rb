module TransactionsHelper
  def transaction_value_color_class(transaction)
    return 'fee-text-color' if transaction.fee? || transaction.manager_visit?
    return 'text-danger' if transaction.withdraw? || transaction.transfer_sent?
    'text-success' if transaction.deposit? || transaction.transfer_received?
  end

  def transaction_value_text_format(value)
    return value.format if value.positive?
    "(#{value.abs.format})"
  end
end
