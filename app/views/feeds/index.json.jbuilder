json.array!(@feeds) do |feed|
  json.extract! feed, :title, :url, :xml_url, :type, :last_checked_at
  json.url feed_url(feed, format: :json)
end