json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :user_id, :feed_id, :folder_id
  json.url subscription_url(subscription, format: :json)
end