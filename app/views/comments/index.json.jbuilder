json.array! @comments do |comment|
  json.extract! comment, :id, :name, :comment
  json.post_id comment.post_id
end