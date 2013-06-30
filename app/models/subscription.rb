# -*- coding: utf-8 -*-
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  belongs_to :folder
  has_many :unread_entries, :dependent => :destroy

  def load_unread_entry
    entry = Entry.arel_table
    Entry.where(entry[:feed_id].eq(self.feed_id)).where(entry[:published_at].gt(1.day.ago)).each do |e|
      self.unread_entries.find_or_create_by(entry_id:e.id, user_id:self.user.id)
    end
  end
end
