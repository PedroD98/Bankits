require 'rails_helper'

describe 'User makes a depoist', type: :system do
  it 'And form exists' do
    user = create(:user)

    login_as user
    visit root_path

    expect(page).to have_content 'Realizar Saque'
    expect(page).to have_field 'Valor (R$)'
    expect(page).to have_button 'Sacar'
  end
end
