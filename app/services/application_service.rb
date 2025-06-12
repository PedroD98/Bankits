class ApplicationService
  def self.call(...)
    new(...).call
  end

  private
  def sanitize_and_validate_value(value_param:, transaction:)
    value = BigDecimal(value_param.to_s.tr(',', '.')) rescue nil

    unless value&.positive?
      transaction.errors.add(:value, 'deve ser positivo')
      return false
    end

    value
  end
end
