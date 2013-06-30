require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name 'amacou'
    provider 'twitter'
    uid '4880381'
  end

  factory :feed do
    title "AorBorF"
    url "http://d.hatena.ne.jp/amacou/"
    xml_url "http://d.hatena.ne.jp/amacou/rss"
    feed_type "rss"
  end
end
