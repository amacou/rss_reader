require 'builder/xmlmarkup'
class FeedsController < ApplicationController
  layout 'setting'
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  def import
  end

  def upload
    xml =  params["opml"]
    doc = Nokogiri::XML(xml.read)
    doc.xpath('//outline[@xmlUrl]').each do |rss|
      subscription = current_user.subscriptions.find_or_create_by(xml_url: rss[:xmlUrl]) do |sub|
        feed = Feed.find_or_create_by(xml_url: rss[:xmlUrl]) do |f|
          f.title = rss[:title]
          f.url = rss[:htmlUrl]
          f.feed_type = rss[:type]
        end
        sub.feed = feed
      end

      if rss.parent && rss.parent.name.downcase == 'outline'
        subscription.folder = Folder.find_or_create_by(user_id:current_user.id, name:rss.parent[:title])
        subscription.save
      end
      subscription.load_unread_entry
    end

    redirect_to ({action: :import}), notice: 'imported!'
  end

  def export
    @subscriptions = current_user.subscriptions.includes(:feed).where(folder: nil)
    @folders = current_user.folders
    @xml = ""
    xml = Builder::XmlMarkup.new(:target => @xml, :indent => 2)
    xml.instruct!
    xml.opml(:version => 1.0) do
      xml.head do
        xml.title 'RSS Reader Subscriptions'
      end
      xml.body do
        @folders.each do |folder|
          xml.outline(
            title: folder.name,
            text: folder.name,
          ){
            folder.feeds.each do |feed|
              xml.outline(
                type: 'rss',
                version: 'RSS',
                description: '',
                title: feed.title,
                htmlUrl: feed.url,
                xmlUrl: feed.xml_url
              )
            end
          }
        end
        @subscriptions.each do |subscription|
          xml.outline(
            :type => 'rss',
            :version => 'RSS',
            :description => '',
            :title => subscription.feed.title,
            :htmlUrl => subscription.feed.url,
            :xmlUrl => subscription.feed.xml_url
          )
        end
      end
    end
    send_data @xml, :type => 'text/xml', :disposition => "attachment; filename=export.xml"
  end
end
