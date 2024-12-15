require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without a name' do
    user = User.new(email: 'test@example.com', password: '123456')
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end
end

RSpec.describe User, type: :model do
  it "is valid with a name, email and password" do
    user = User.new(name: "Valid User", email: "valid@example.com", password: "123456", password_confirmation: "123456")
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(email: "no_name@example.com", password: "123456", password_confirmation: "123456")
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a unique email" do
    User.create(name: "User1", email: "duplicate@example.com", password: "123456", password_confirmation: "123456")
    user = User.new(name: "User2", email: "duplicate@example.com", password: "123456", password_confirmation: "123456")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end
end