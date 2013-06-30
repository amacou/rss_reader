# -*- coding: utf-8 -*-
require 'open-uri'
class Feed < ActiveRecord::Base
  has_many :subscriptions
  has_many :entries
  has_many :users, :through => :subscriptions
  has_many :unread_entries, :through => :subscriptions

  after_create :pull
  MAX_ENTRY_COUNT = 500

  def self.subscribe_from_url(url)
    feed = Feed.where(url: url).first

    unless feed
      doc = Nokogiri::HTML(open(url))
      if doc.xpath("//head/link[@type='application/rss+xml']").length > 0
        rsslink = doc.xpath("//head/link[@type='application/rss+xml']")
        feed = Feed.new
        feed.url = url
        feed.title = rsslink.attr('title').to_s
        feed.xml_url = rsslink.attr('href').to_s
        feed.feed_type = 'rss'
        feed.save
      else
        return nil
      end
    end
    feed
  end


  def fetch_header
    header = {}
    header[:if_modified_since] = self.last_modified_at  if self.last_modified_at
    header[:if_none_match] = self.etag if self.etag
    header
  end

  def pull
    Rails.logger.info "pull start #{self.title}, #{self.xml_url}"
    if self.error_count > 0 && self.error_count > self.skip_count
      self.skip_count += 1
      self.save
      Rails.logger.info "skip"
      return nil
    end
    t = Time.now
    begin
      rss = Feedzirra::Feed.fetch_and_parse(self.xml_url, fetch_header)
      if rss && !rss.instance_of?(Fixnum)
        self.title = rss.title if rss.title && rss.title != self.title
        self.url = rss.url if rss.url && rss.url != self.url
        rss.entries = rss.entries.split(0..MAX_ENTRY_COUNT) if rss.entries.length > MAX_ENTRY_COUNT
        rss.entries.each do |item|
          entry = self.entries.find_or_create_by(link: item.url) do |e|
            e.title = item.title
            e.link = item.url
            e.description = item.content || item.summary
            e.author = item.author
            e.published_at = item.published
          end
        end
        self.last_modified_at = rss.last_modified
        self.etag = rss.etag
        delete_protrusionly_entry
      end
      self.last_checked_at = t
      self.skip_count = 0
      self.error_count = 0
      self.save
    rescue => e
      puts "******Error******"
      Rails.logger.error e
      after_pull_error
    end
  end

  def delete_protrusionly_entry
    if self.entries.count > MAX_ENTRY_COUNT
      entries = self.entries.order("published_at DESC").offset(MAX_ENTRY_COUNT)
      entries.destroy_all
    end
  end

  def after_pull_error
    begin
      self.skip_count = 0
      self.error_count += 1
      self.save
    rescue => e
      puts "******Error******"
      Rails.logger.error e
    end
  end
  def self.pull_all(force = false)
    # Parallel.each(Feed.all, :in_threads => 4) do |f|
    #   ActiveRecord::Base.connection_pool.with_connection do
    #     f.pull if force || f.last_checked_at.nil? || f.last_checked_at < 15.minutes.ago
    #   end
    # end
    Parallel.each(Feed.all, :in_processes => 4) do |f|
      ActiveRecord::Base.connection.reconnect!
      f.pull if force || f.last_checked_at.nil? || f.last_checked_at < 15.minutes.ago
    end
  end
end
