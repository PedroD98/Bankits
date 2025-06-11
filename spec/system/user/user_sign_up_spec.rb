require 'rails_helper'

describe 'User creates account', type: :system do
  it 'and registration page exists' do
    visit root_path
    click_on 'Inscrever-se'

    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'Número da conta'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
  end

  it 'and fields can not be blank' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'Número da conta', with: ''
    fill_in 'Senha', with: ''
    within 'form' do
      click_on 'Inscrever-se'
    end

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'Número da conta não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  it 'and must fill every field correctly' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'P3dr0'
    fill_in 'Sobrenome', with: 'Iv°'
    fill_in 'Número da conta', with: '199F8'
    fill_in 'Senha', with: '443R'
    fill_in 'Confirme sua senha', with: '443R'
    within 'form' do
      click_on 'Inscrever-se'
    end

    expect(page).to have_content 'Nome deve conter apenas letras e espaços'
    expect(page).to have_content 'Sobrenome deve conter apenas letras e espaços'
    expect(page).to have_content 'Número da conta deve conter apenas 5 dígitos (0-9)'
    expect(page).to have_content 'Senha deve conter apenas 4 dígitos (0-9)'
  end

  it 'with sucess' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Ivo'
    fill_in 'Número da conta', with: '19984'
    fill_in 'Senha', with: '4435'
    fill_in 'Confirme sua senha', with: '4435'
    within 'form' do
      click_on 'Inscrever-se'
    end

    expect(current_path).to eq root_path
    expect(User.count).to eq 1
    expect(User.first.first_name). to eq 'Pedro'
    expect(User.first.last_name). to eq 'Ivo'
    expect(User.first.acc_number). to eq '19984'
    expect(User.first.balance_cents). to eq 0
    expect(User.first.user_type). to eq 'regular'
  end
end
