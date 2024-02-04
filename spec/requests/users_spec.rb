require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    context "with valid parameters" do
      # attributes_for is an inbuilt method in factory_bot
      let(:valid_params) { attributes_for(:user) }

      before do
          post "/register", params: valid_params
      end

      it "should return a created HTTP status" do
          expect(response).to have_http_status(:created)
      end      
      
      it "should have valid body" do
          expect(JSON.parse(response.body)).to include("username", "email")
      end
    end
  
    context "with invalid parameters" do
      let(:invalid_params) { attributes_for(:user, email: "invalid_email") }
      
      before do
          post "/register", params: invalid_params
      end
      
      it "should return an unprocessable_entity HTTP status" do
          expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "should return error message" do
          expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  

  describe "GET /users" do
    let!(:user) { create :user }
    let(:token) { JsonWebToken.encode(user_id: user.id)}

    before do
      get "/users", headers: { 'Authorization' => "Bearer #{token}" }
    end

    it 'should return an array' do
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end

    it 'should return all the users' do
      expect(JSON.parse(response.body).length).to eq(User.count)
    end
  
    it 'should return an ok HTTP status' do
        expect(response).to have_http_status(:ok)
    end
  end


  describe "GET /users/:id" do
    let!(:user) { create :user }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    context 'when the user.id is current_user.id' do
      before do
        get "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
      end
    
      it 'should return a successful response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user.id is not current_user.id' do
      before do
        get "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}prev_token" }
      end
      
      it 'should return an unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  
  describe "DELETE /users/:id" do
    let!(:user) { create :user }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    
    context 'when the user.id is current_user.id' do
      before do
        delete "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
      end
      
      it 'should return a no content response' do
        expect(response).to have_http_status(:no_content)
      end
      
      it 'should delete the user' do
        expect(User.exists?(user.id)).to be_falsey
      end
    end
    
    context 'when user.id is not current_user.id' do
      before do
        delete "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}prev_token" }
      end
      
      it 'should return an unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
end
