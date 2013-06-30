json.array!(@folders) do |folder|
  json.extract! folder, :user_id, :name
  json.url folder_url(folder, format: :json)
end