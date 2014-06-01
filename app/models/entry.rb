require 'time'
class Entry < ActiveRecord::Base
  belongs_to :feed

  has_many :unread_entries, :dependent => :destroy

  after_create :create_unread_entries

  scope :unread, -> { joins(:unread_entries).where(['unread_entries.readed=?',false])}

  def create_unread_entries
    self.feed.subscriptions.find_each do |sub|
      ue = sub.unread_entries.new
      sub.user.unread_entries << ue
      ue.entry_id = self.id
      ue.weight = self.weight
      ue.save
    end
  end

  def weight
    "#{self.published_at.to_i}.#{self.id}"
  end
  def published_date
    self.published_at.iso8601 if self.published_at
  end
end
