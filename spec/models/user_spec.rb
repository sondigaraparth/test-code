require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'Devise modules' do
    it { is_expected.to be_a_kind_of(Devise::Models::DatabaseAuthenticatable) }
    it { is_expected.to be_a_kind_of(Devise::Models::Registerable) }
    it { is_expected.to be_a_kind_of(Devise::Models::Recoverable) }
    it { is_expected.to be_a_kind_of(Devise::Models::Rememberable) }
    it { is_expected.to be_a_kind_of(Devise::Models::Validatable) }
  end

  describe 'Associations' do
    it 'has many posts and destroys them when user is deleted' do
      user = create(:user)
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)
  
      expect(user.posts).to include(post1, post2)
  
      expect { user.destroy }.to change { Post.count }.by(-2)
    end
  end

  describe 'Validations' do
    it 'is invalid without an email' do
      user = User.new(password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  
    it 'is invalid without a password' do
      user = User.new(email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  
    it 'is invalid with a duplicate email' do
      User.create(email: 'test@example.com', password: 'password')
      user = User.new(email: 'test@example.com', password: 'anotherpass')
  
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end
  end
end
