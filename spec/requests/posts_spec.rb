require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  describe "POST /upload" do
    context "with valid params" do
      let(:valid_params) { attributes_for(:post) }
      
      before do
        post_params = { post: valid_params }
        post "/upload", params: post_params, headers: { 'Authorization': "Bearer #{token}" }
      end
      
      it "should return an ok HTTP ststus" do
        expect(response).to have_http_status(:ok)
      end
      
      it "should return a valid body" do
        expect(JSON.parse(response.body)["title"]).to eq(valid_params[:title])
      end
    end
    
    context "with invalid params" do
      let(:invalid_params) { attributes_for(:post, title: "") }
      
      before do
        post_params = { post: invalid_params }
        post "/upload", params: post_params, headers: { 'Authorization': "Bearer #{token}" }
      end

      it "should return unprocessable entity response" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return an error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end


  describe "GET /posts" do
    before do
      get "/posts", headers: { 'Authorization': "Bearer #{token}" }
    end
    
    it "should return an ok HTTP status" do
      expect(response).to have_http_status(:ok)
    end
    
    it "should return an array" do
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end
  
  
  describe "GET /posts/:id" do
    let!(:post) {create(:post, user: user)}
    
    
    context "when the post exists" do
      before do
        get "/posts/#{post.id}", headers: { 'Authorization': "Bearer #{token}" }
      end
      
      it 'should return the requested post' do
        expect(JSON.parse(response.body)['id']).to eq(post.id)
      end
      
      it "should return an ok HTTP status" do
        expect(response).to have_http_status(:ok)
      end
    end
    
    context "when the post does not exist" do
      before do
        get "/posts/403", headers: { 'Authorization': "Bearer #{token}" }
      end
      # let(:post_id) {"invalid"}
      
      it "should return a not found status" do
        expect(response).to have_http_status(:not_found)
      end
      
      it "should return an error message of post not found" do
        expect(JSON.parse(response.body)["errors"]).to eq("Post not found")
      end
    end
  end


  describe "DELETE /posts/:id" do
    let!(:post) {create(:post, user: user)}
    
    context "when the post exists" do
      before do
        delete "/posts/#{post.id}", headers: { 'Authorization': "Bearer #{token}" }
      end
      
      it "should return a no content status" do
        expect(response).to have_http_status(:no_content)
      end
      
    end
    
    context "when the post does not exists" do
      before do
        delete "/posts/403", headers: { 'Authorization': "Bearer #{token}" }
      end
      
      it "should return an error message of Post not found" do
        expect(JSON.parse(response.body)["errors"]).to eq("Post not found")
      end

      it "should return a not found status" do
        expect(response).to have_http_status(:not_found)
      end 
    end
  end
end
