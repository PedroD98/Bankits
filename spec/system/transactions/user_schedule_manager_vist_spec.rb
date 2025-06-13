require 'rails_helper'

describe 'Vip user schedule manager visit', type: :system do
  it 'and link should be visible' do
    user = create(:user, :vip)

    login_as user
    visit root_path

    expect(page).to have_link 'Visita gerencial'
  end

  it 'and link should not be visible for if user_type is regular' do
    user = create(:user, user_type: :regular)

    login_as user
    visit root_path

    expect(page).not_to have_link 'Visita gerencial'
  end

  it 'and modal can not be accessed by regular users' do
    user = create(:user, user_type: :regular)

    login_as user
    visit new_manager_visit_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Essa funcionalidade só é permitida para usuários vips.'
  end

  it 'and schedule form exists' do
    user = create(:user, :vip)

    login_as user
    visit root_path
    click_on 'Visita gerencial'


    expect(page).to have_content 'Agendamento de visita gerencial'
    expect(page).to have_content 'Uma taxa de R$ 50,00 será debitada da sua conta'
    expect(page).to have_field 'Data de agendamento da visita'
    expect(page).to have_button 'Confirmar agendamento'
    expect(page).to have_button 'Cancelar'
  end

  it 'and form can not be blank' do
    user = create(:user, :vip)

    login_as user
    visit root_path
    click_on 'Visita gerencial'
    click_on 'Confirmar agendamento'


    expect(page).to have_content 'Falha ao agendar visita.'
    expect(page).to have_content 'É necessário escolher uma data.'
    expect(page).to have_content 'Não pode ser uma data passada.'
    expect(Transaction.all.count).to eq 0
  end

  it 'and schedule date can not be in the past' do
    user = create(:user, :vip)

    login_as user
    travel_to Time.zone.local(2000, 07, 15) do
      visit root_path
      click_on 'Visita gerencial'
      fill_in 'Data de agendamento da visita', with: '2000-07-14'
      click_on 'Confirmar agendamento'

      expect(page).to have_content 'Não pode ser uma data passada.'
      expect(Transaction.all.count).to eq 0
    end
  end

  it 'with success' do
    user = create(:user, :vip, balance: 60)

    login_as user
    travel_to Time.zone.local(2000, 07, 15) do
      visit root_path
      click_on 'Visita gerencial'
      fill_in 'Data de agendamento da visita', with: '2000-07-16'
      click_on 'Confirmar agendamento'

      user.reload
      expect(page).to have_content 'Visita agendada com sucesso!'
      expect(Transaction.all.count).to eq 1
      expect(user.balance.format).to eq 'R$ 10,00'
    end
  end
end
