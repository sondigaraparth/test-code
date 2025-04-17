require 'rails_helper'

RSpec.describe 'User Registrations', type: :request do
  describe 'POST /users' do
    it 'registers a new user' do
      user_params = {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      post '/users', params: user_params

      expect(response).to have_http_status(:created).or have_http_status(:redirect)
      expect(User.last.email).to eq('test@example.com')
    end
  end
end
