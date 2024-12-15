require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "GET /users" do
    it "returns a list of users" do
      User.create(name: "John", email: "john@example.com", password: "123456")
      get "/users", headers: { "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json[0]['name']).to eq("John")
    end
  end
end

require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /users" do
    it "creates a new user" do
      user_params = {
        name: "New User",
        email: "newuser@example.com",
        password: "123456",
        password_confirmation: "123456"
      }

      # Aqui adicionamos Accept e Content-Type para JSON
      post "/users", params: user_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("New User")
      expect(json["email"]).to eq("newuser@example.com")
    end
  end
end
