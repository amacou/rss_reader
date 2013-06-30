class User < ActiveRecord::Base
  has_many :folders
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :unread_entries
  has_many :entries, :through => :unread_entries
  SORT_TYPES = [SORT_TYPE_DESC = "DESC", SORT_TYPE_ASC = "ASC"]
  validates_inclusion_of :sort_type, :in => SORT_TYPES

  def self.create_with_omniauth(auth)
    create!do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.sort_type = SORT_TYPE_DESC
    end
  end

  def subscribe(url)
    subscription = self.subscriptions.joins(:feed).where('feeds.url'=> url).first
    unless subscription
      subscription = self.subscriptions.build
    end


    if feed = Feed.subscribe_from_url(url)
      subscription.feed = feed
      subscription.load_unread_entry if subscription.save
      return true
    end

    return false
  end

  def unsubscribe(subsctiptions)
    subscription_table = Subscription.arel_table
    subscriptions = current_user.subscriptions.where(subscription_table[:id].in(subscription_ids))
    subscriptions.each do |subscription|
      subscription.destroy
    end

  end
end
