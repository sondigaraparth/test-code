require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { build(:post) }

  describe "validations" do
    it 'invalid title' do
      user = create(:user)
      post = Post.new(content: "test content", user: user)

      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end
    it 'invalid content' do
      user = create(:user)
      post = Post.new(title: "test title", user: user)

      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("can't be blank")
    end
  end

  describe 'Associations' do
    it 'belongs to a user' do
      post = build(:post)
      expect(post.user).to be_a(User)
    end
  end
end
