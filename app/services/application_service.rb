class ApplicationService
  def self.call(...)
    new(...).call
  end

  private
  def sanitize_and_validate_value(value_param:, transaction:)
    value = BigDecimal(value_param.to_s.tr(',', '.')) rescue nil
    if value.nil?
      transaction.errors.add(:value, 'deve ser inserido')
      return false
    end
    if value&.negative?
      transaction.errors.add(:value, 'deve ser positivo')
      return false
    end

    value
  end
end
