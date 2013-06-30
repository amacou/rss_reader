# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unread_entry do
    user_id 1
    entry_id 1
    subscription_id 1
    readed false
  end
end
