require 'rails_helper'

describe 'User makes a depoist', type: :system do
  it 'And form exists' do
    user = create(:user)

    login_as user
    visit root_path

    expect(page).to have_content 'Realizar Depósito'
    expect(page).to have_field 'Valor (R$)'
    expect(page).to have_button 'Depositar'
  end

  it 'and value can not be blank' do
    user = create(:user)

    login_as user
    visit root_path
    within '#deposit_value_field' do
      fill_in 'Valor (R$)', with: ''
    end
    click_on 'Depositar'

    expect(page).to have_content 'Falha ao realizar depósito'
    expect(page).to have_content 'Valor deve ser positivo'
    expect(Transaction.all.count).to eq 0
  end

  it 'and value can not be negative' do
    user = create(:user)

    login_as user
    visit root_path
    within '#deposit_value_field' do
      fill_in 'Valor (R$)', with: -9.99
    end
    click_on 'Depositar'

    expect(page).to have_content 'Falha ao realizar depósito'
    expect(page).to have_content 'Valor deve ser positivo'
    expect(Transaction.all.count).to eq 0
  end


  it 'with success' do
    user = create(:user)

    login_as user
    visit root_path
    save_page
    within '#deposit_value_field' do
      fill_in 'Valor (R$)', with: 9.99
    end
    click_on 'Depositar'

    expect(page).to have_content 'Depósito realizado com sucesso!'
    expect(Transaction.all.count).to eq 1
    expect(user.transactions.count).to eq 1
    expect(user.transactions.first.value_cents).to eq 999
  end

  it 'should update user balance' do
    user = create(:user, balance_cents: 1000)

    login_as user
    visit root_path
    save_page
    within '#deposit_value_field' do
      fill_in 'Valor (R$)', with: 9.99
    end
    click_on 'Depositar'

    user.reload
    expect(user.balance_cents).to eq 1999
  end
end
