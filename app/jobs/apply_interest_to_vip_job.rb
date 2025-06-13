class ApplyInterestToVipJob < ApplicationJob
  queue_as :default

  def perform
    puts "Rodando ApplyInterestToVipJob em: #{I18n.l(Time.current, format: :long)}"

    negative_balance_vips = User.where(user_type: :vip).where('balance_cents < 0')
    puts "Nenhum usuário VIP com saldo negativo encontrado." if negative_balance_vips.empty?

    negative_balance_vips.each do |user|
      puts "Aplicando taxa de juros para o usário #{user.full_name} / #{user.acc_number}, com saldo #{user.balance.format}"
      InterestService.call(vip_user: user)
    end
  end
end
