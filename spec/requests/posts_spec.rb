require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { User.create(name: "Author", email: "author@example.com", password: "123456", password_confirmation: "123456") }

  # Método helper para obter token
  def auth_token_for_user(user_email, user_password)
    post "/auth/login", params: { email: user_email, password: user_password }.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
    JSON.parse(response.body)["token"]
  end

  describe "POST /posts" do
    it "creates a new post for an authenticated user" do
      token = auth_token_for_user("author@example.com", "123456")

      post_params = {
        title: "Meu Post",
        text: "Conteúdo do meu post"
      }

      post "/posts", params: post_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json", "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Meu Post")
      expect(json["text"]).to eq("Conteúdo do meu post")
      expect(json["user"]["email"]).to eq("author@example.com")
    end

    it "returns unauthorized without a token" do
      post_params = { title: "Post sem autenticação", text: "Texto" }
      post "/posts", params: post_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end