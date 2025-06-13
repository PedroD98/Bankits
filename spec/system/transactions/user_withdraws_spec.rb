require 'rails_helper'

describe 'User withdraws', type: :system do
  it 'and must be logged in' do
    visit statements_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'And form exists' do
    user = create(:user)

    login_as user
    visit root_path

    expect(page).to have_content 'Realizar Saque'
    expect(page).to have_field 'Valor (R$)'
    expect(page).to have_button 'Sacar'
  end

  it 'and value can not be blank' do
    user = create(:user)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: ''
    end
    click_on 'Sacar'

    expect(page).to have_content 'Falha ao realizar saque'
    expect(page).to have_content 'Valor deve ser inserido'
    expect(Transaction.all.count).to eq 0
  end

  it 'and value can not be negative' do
    user = create(:user)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: -9.99
    end
    click_on 'Sacar'

    expect(page).to have_content 'Falha ao realizar saque'
    expect(page).to have_content 'Valor deve ser positivo'
    expect(Transaction.all.count).to eq 0
  end

  it 'with success' do
    user = create(:user, balance_cents: 1000)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: 9.99
    end
    click_on 'Sacar'

    expect(page).to have_content 'Saque realizado com sucesso!'
    expect(Transaction.all.count).to eq 1
    expect(user.transactions.count).to eq 1
    expect(user.transactions.first.value_cents).to eq(-999)
  end

  it 'and value can not be greater than balance if user_type is regular' do
    user = create(:user, balance_cents: 998)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: 9.99
    end
    click_on 'Sacar'

    expect(page).to have_content 'Falha ao realizar saque'
    expect(page).to have_content 'Saldo insuficiente.'
    expect(Transaction.all.count).to eq 0
  end

  it 'and value can not be greater than balance if user_type is vip' do
    user = create(:user, :vip, balance: 10)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: 20
    end
    click_on 'Sacar'

    user.reload
    expect(page).to have_content 'Saque realizado com sucesso!'
    expect(Transaction.all.count).to eq 1
    expect(user.balance.format).to eq 'R$ -10,00'
  end

  it 'and their balance is updated' do
    user = create(:user, balance_cents: 1000)

    login_as user
    visit root_path
    within '#withdraw_value_field' do
      fill_in 'Valor (R$)', with: 9.99
    end
    click_on 'Sacar'

    user.reload
    expect(user.balance_cents).to eq 1
  end
end
