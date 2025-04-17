require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'POST /users' do
    it 'registers a new user' do
      post '/users', params: {
        user: {
          email: 'new_user@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      expect(response).to have_http_status(:redirect) # Devise redirects by default
      expect(User.last.email).to eq('new_user@example.com')
    end
  end

  describe 'POST /users/sign_in' do
    it 'signs in the user with correct credentials' do
      post '/users/sign_in', params: {
        user: {
          email: user.email,
          password: 'password123'
        }
      }

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      # expect(response.body).to include("Signed in successfully").or include("Dashboard") # adjust based on your app
    end

    it 'does not sign in with incorrect password' do
      post '/users/sign_in', params: {
        user: {
          email: user.email,
          password: 'wrongpassword'
        }
      }

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok) # depending on how you handle errors
      # expect(response.body).to include('Invalid Email or password').or include('error')
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'signs out the logged in user' do
      sign_in user

      delete '/users/sign_out'

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      # expect(response.body).to include('Signed out successfully').or include('Login')
    end
  end
end
