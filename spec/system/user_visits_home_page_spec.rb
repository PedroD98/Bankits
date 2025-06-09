require 'rails_helper'

describe 'User access home page', type: :system do
  it 'and see the app name' do
    visit root_path

    expect(page).to have_content 'Bankits'
  end
end
