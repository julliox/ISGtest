json.array! @posts do |post|
  json.extract! post, :id, :title, :text
  json.user do
    json.extract! post.user, :id, :name, :email
  end
end