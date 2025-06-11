require 'rails_helper'

describe 'User signs in', type: :system do
  it 'and log in page exists' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login'
    expect(page).to have_field 'Número da conta'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Login'
  end

  it 'and must fill every form field' do
    User.create!(first_name: 'Pedro', last_name: 'Ivo',
                 acc_number: '43353', password: '1111', balance_cents: 4599)

    visit root_path
    fill_in 'Número da conta', with: ''
    fill_in 'Senha', with: ''
    within 'form' do
      click_on 'Login'
    end

    expect(page).to have_content 'Número da conta ou senha inválidos.'
    expect(page).not_to have_button 'Sair'
  end

  it 'with success' do
    User.create!(first_name: 'Pedro', last_name: 'Ivo',
                 acc_number: '43353', password: '1111', balance_cents: 4599)

    visit root_path
    fill_in 'Número da conta', with: '43353'
    fill_in 'Senha', with: '1111'
    within 'form' do
      click_on 'Login'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bankits'
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Olá, Pedro'
    expect(page).to have_content 'R$ 45,99'
  end

  it 'and logs out' do
    user = User.create!(first_name: 'Pedro', last_name: 'Ivo',
                        acc_number: '43353', password: '1111')

    login_as user
    visit root_path
    click_on 'Sair'

    expect(current_path).to eq root_path
    expect(page).to have_button 'Login'
  end
end
