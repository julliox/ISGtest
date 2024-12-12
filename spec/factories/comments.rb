FactoryBot.define do
  factory :comment do
    name { "MyString" }
    comment { "MyText" }
    post { nil }
  end
end
