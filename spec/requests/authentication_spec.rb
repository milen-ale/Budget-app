require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  it 'renders the splash screen for signed-out visitors' do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Budget App')
  end

  it 'redirects signed-out visitors to sign in on protected pages' do
    get budget_categories_path

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'shows the dashboard to signed-in users' do
    user = User.create!(name: 'Alia', email: 'alia@example.com', password: 'password123')
    sign_in user

    get budget_categories_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Hi, Alia')
  end
end
