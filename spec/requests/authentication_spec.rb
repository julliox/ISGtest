require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /auth/login" do
    let!(:user) { User.create(name: "John", email: "john@example.com", password: "123456", password_confirmation: "123456") }

    it "returns a JWT token for valid credentials" do
      login_params = { email: "john@example.com", password: "123456" }
      post "/auth/login", params: login_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).not_to be_nil
    end

    it "returns unauthorized for invalid credentials" do
      login_params = { email: "john@example.com", password: "wrongpassword" }
      post "/auth/login", params: login_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Credenciais inválidas")
    end
  end
end