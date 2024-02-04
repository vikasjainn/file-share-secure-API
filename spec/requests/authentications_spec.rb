require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user, email: "brad.pitt@gmail.com", password: "brad.pitt403") }

    context "with valid credentials" do
      before do
        post "/login", params: { email: "brad.pitt@gmail.com", password: "brad.pitt403" }
      end

      it "should return an ok HTTP status" do
        expect(response).to have_http_status(:ok)
      end

      it "should return a JWT token" do
        expect(JSON.parse(response.body)).to include("token", "exp", "username")
      end
    end

    context "with invalid credentials" do
      before do
        post "/login", params: { email: "brad.pitt@gmail.com", password: "invalid" }
      end

      it "should return an unauthorized HTTP status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "should return error message" do
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "POST /logout" do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    before do
      post "/logout", headers: { 'Authorization': "Bearer #{token}" }
    end

    it "should return an ok HTTP status" do
      expect(response).to have_http_status(:ok)
    end

    it "should return a success message" do
      expect(JSON.parse(response.body)).to include("message" => "Logged out successfully")
    end
  end
end

