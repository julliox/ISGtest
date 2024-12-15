require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { User.create(name: "John", email: "john@example.com", password: "123456") }
  let!(:post_record) { Post.create(title: "Post Teste", text: "Conteúdo", user: user) }

  describe "POST /comments" do
    it "creates a comment for a post" do
      comment_params = {
        name: "Comentador",
        comment: "Muito bom esse post!",
        post_id: post_record.id
      }

      post "/comments", params: comment_params.to_json, headers: { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Comentador")
      expect(json["comment"]).to eq("Muito bom esse post!")
      expect(json["post_id"]).to eq(post_record.id)
    end
  end

  describe "GET /comments" do
    before do
      Comment.create(name: "User1", comment: "Primeiro comentário", post: post_record)
      Comment.create(name: "User2", comment: "Segundo comentário", post: post_record)
    end

    it "lists all comments" do
      get "/comments", headers: { "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.map { |c| c["name"] }).to include("User1", "User2")
    end
  end
end