require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let(:user) { create(:user) }
  let!(:post_record) { create(:post, user: user) }

  before do
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'password123'
      }
    }

    follow_redirect! # Optional: follow redirect after sign-in
  end

  describe 'GET /posts' do
    it "signs the user in and gets posts" do
  
      get posts_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Your Posts')
    end
  end

  describe 'POST /posts' do
    context 'with valid params' do
      it 'creates a new post and returns a Turbo Stream response' do
        expect {
          post posts_path,
               params: { post: { title: 'New Post', content: 'Some content' } },
               headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
        }.to change(Post, :count).by(1)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include('<turbo-stream')
        expect(response.body).to include('New Post')
      end
    end
  
    context 'with invalid params' do
      it 'does not create a new post and shows errors' do
        expect {
          post posts_path, params: { post: { title: '', content: '' } },
          headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
        }.not_to change(Post, :count)
        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
        expect(response.body).to include('<turbo-stream').or include('Title can\'t be blank')
      end
    end
  end
  

  # describe 'GET /posts/:id/edit' do
  #   it 'renders the edit page' do
  #     get edit_post_path(post_record)
  #     expect(response).to have_http_status(:ok)
  #     expect(response.body).to include(post_record.title)
  #   end
  # end

  # describe 'PATCH /posts/:id' do
  #   context 'with valid params' do
  #     it 'updates the post' do
  #       patch post_path(post_record), params: { post: { title: 'Updated Title' } }
  #       expect(response).to redirect_to(posts_path)
  #       follow_redirect!
  #       expect(response.body).to include('Post updated.')
  #       expect(post_record.reload.title).to eq('Updated Title')
  #     end
  #   end

  #   context 'with invalid params' do
  #     it 'does not update the post' do
  #       patch post_path(post_record), params: { post: { title: '' } }
  #       expect(response).to have_http_status(:ok)
  #       expect(response.body).to include('error').or include('Title')
  #     end
  #   end
  # end

  # describe 'DELETE /posts/:id' do
  #   it 'deletes the post' do
  #     expect {
  #       delete post_path(post_record)
  #     }.to change(Post, :count).by(-1)

  #     expect(response).to redirect_to(posts_path)
  #     follow_redirect!
  #     expect(response.body).to include('Post deleted.')
  #   end
  # end
end
