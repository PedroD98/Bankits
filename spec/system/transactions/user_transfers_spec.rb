require 'rails_helper'

describe 'User send a transfer', type: :system do
  it 'and must be logged in' do
    visit statements_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and form exists' do
    user = create(:user)

    login_as user
    visit root_path

    within '#transfer_card' do
      expect(page).to have_content 'Transferir'
      expect(page).to have_field 'Número da conta'
      expect(page).to have_field 'Valor (R$)'
      expect(page).to have_button 'Transferir'
    end
  end

  it 'and fields can not be blank' do
    user = create(:user)

    login_as user
    visit root_path
    within '#transfer_card' do
      fill_in 'Número da conta', with: ''
      fill_in 'Valor (R$)', with: ''
      click_on 'Transferir'
    end
    expect(page).to have_content 'Valor deve ser inserido'
    expect(page).to have_content 'Contraparte não encontrado.'
    expect(page).to have_content 'Falha ao realizar transferência'
    expect(Transaction.all.count).to eq 0
  end

  it 'and counterpaty account number must be an existing account' do
    user = create(:user)
    create(:user, acc_number: '12345')

    login_as user
    visit root_path
    within '#transfer_card' do
      fill_in 'Número da conta', with: '11111'
      fill_in 'Valor (R$)', with: '10.20'
      click_on 'Transferir'


      expect(page).to have_content 'Contraparte não encontrado.'
    end
    expect(page).to have_content 'Falha ao realizar transferência'
    expect(Transaction.all.count).to eq 0
  end

  context 'REGULAR USERS' do
    it 'and value can not be greater than user balance if user_type is regular' do
      first_user = create(:user, user_type: :regular, balance: 10)
      create(:user, acc_number: '12345')

      login_as first_user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '10.01'
        click_on 'Transferir'

        expect(page).to have_content 'Saldo insuficiente.'
      end
      expect(page).to have_content 'Falha ao realizar transferência.'
      expect(Transaction.all.count).to eq 0
    end

    it 'and value can not be greater than 1000 if user_type is regular' do
      first_user = create(:user, user_type: :regular)
      create(:user, acc_number: '12345')

      login_as first_user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '1000.01'
        click_on 'Transferir'

        expect(page).to have_content 'Valor não pode exceder R$ 1000,00'
      end
      expect(page).to have_content 'Falha ao realizar transferência'
      expect(Transaction.all.count).to eq 0
    end

    it 'and regular user fee is calculated correctly' do
      user = create(:user, user_type: :regular, balance: 150)
      create(:user, acc_number: '12345')

      login_as user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '50'
        click_on 'Transferir'
      end

      user.reload
      expect(user.transactions.last.transaction_type).to eq 'fee'
      expect(user.transactions.last.value.format).to eq 'R$ -8,00'
    end
  end

  context 'VIP USERS' do
    it 'and value can be greater than user balance if user_type is vip' do
      user = create(:user, :vip, balance: 10)
      create(:user, acc_number: '12345', first_name: 'Pedro Ivo', last_name: 'Dias')

      login_as user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '20'
        click_on 'Transferir'
      end

      user.reload
      expect(page).to have_content 'Transferência realizada com sucesso!'
      expect(page).to have_content 'TRANSFERÊNCIA ENVIADA PARA PEDRO IVO DIAS'
      expect(Transaction.all.count).to eq 3
      expect(user.transactions.all.count).to eq 2
      expect(user.balance.format).to eq 'R$ -10,16'
    end

    it 'and value can be greater than 1000 if user_type is vip' do
      user = create(:user, :vip, balance: 5000)
      create(:user, acc_number: '12345', first_name: 'Pedro Ivo', last_name: 'Dias')

      login_as user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '1000.01'
        click_on 'Transferir'
      end

      user.reload
      expect(page).to have_content 'Transferência realizada com sucesso!'
      expect(page).to have_content 'TRANSFERÊNCIA ENVIADA PARA PEDRO IVO DIAS'
      expect(Transaction.all.count).to eq 3
      expect(user.transactions.all.count).to eq 2
      expect(user.balance.format).to eq 'R$ 3.991,99'
    end

    it 'and vip user fee is calculated correctly' do
      user = create(:user, :vip, balance: 150)
      create(:user, acc_number: '12345')

      login_as user
      visit root_path
      within '#transfer_card' do
        fill_in 'Número da conta', with: '12345'
        fill_in 'Valor (R$)', with: '50'
        click_on 'Transferir'
      end

      user.reload
      expect(user.transactions.last.transaction_type).to eq 'fee'
      expect(user.transactions.last.value.format).to eq 'R$ -0,40'
    end
  end



  it 'when successeful, it should create all 3 transactions correctly' do
    first_user = create(:user, balance: 150, first_name: 'Ana Maria', last_name: 'Ferreira')
    second_user = create(:user, acc_number: '12345', balance: 30, first_name: 'Pedro Ivo', last_name: 'Dias')

    login_as first_user
    visit root_path
    within '#transfer_card' do
      fill_in 'Número da conta', with: '12345'
      fill_in 'Valor (R$)', with: '100'
      click_on 'Transferir'
    end

    first_user.reload
    second_user.reload
    first_user_transfer_sent = first_user.transactions.first
    first_user_transfer_fee = first_user.transactions.last
    second_user_transer_received = second_user.transactions.first
    expect(page).to have_content 'Transferência realizada com sucesso!'
    expect(Transaction.all.count).to eq 3
    expect(first_user.balance.format).to eq 'R$ 42,00'
    expect(second_user.balance.format).to eq 'R$ 130,00'
    expect(first_user.transactions.all.count).to eq 2
    expect(first_user_transfer_sent.transaction_type).to eq 'transfer_sent'
    expect(first_user_transfer_sent.value.format).to eq 'R$ -100,00'
    expect(first_user_transfer_sent.description).to eq 'TRANSFERÊNCIA ENVIADA PARA PEDRO IVO DIAS'
    expect(first_user_transfer_sent.counterparty).to eq second_user
    expect(first_user_transfer_fee.transaction_type).to eq 'fee'
    expect(first_user_transfer_fee.value.format).to eq 'R$ -8,00'
    expect(first_user_transfer_fee.description).to eq 'TAXA DE TRANSFERÊNCIA'
    expect(second_user.transactions.all.count).to eq 1
    expect(second_user_transer_received.transaction_type).to eq 'transfer_received'
    expect(second_user_transer_received.value.format).to eq 'R$ 100,00'
    expect(second_user_transer_received.description).to eq 'TRANSFERÊNCIA RECEBIDA DE ANA MARIA FERREIRA'
    expect(second_user_transer_received.counterparty).to eq first_user
  end
end
