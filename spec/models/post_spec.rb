require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create(name: "Author", email: "author@example.com", password: "123456", password_confirmation: "123456") }

  it "is valid with title and text and user" do
    post_record = Post.new(title: "Title", text: "Some text", user: user)
    expect(post_record).to be_valid
  end

  it "is invalid without a title" do
    post_record = Post.new(text: "Some text", user: user)
    expect(post_record).not_to be_valid
    expect(post_record.errors[:title]).to include("can't be blank")
  end
end