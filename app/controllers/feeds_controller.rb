require 'builder/xmlmarkup'
class FeedsController < ApplicationController
  layout 'setting'
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  def subscribe
    respond_to do |format|
      if current_user.subscribe(params[:url])
        format.html { redirect_to reader_path, notice: 'rss feed was successfully add.' }
        format.json { head :no_content }
      else
        format.html { redirect_to reader_path, notice: 'rss feed was faild to add' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

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
  end

  def export
    @feeds = current_user.feeds.all
    @folders = current_user.folders
    @xml = ""
    xml = Builder::XmlMarkup.new(:target => @xml, :indent => 2)
    xml.instruct!
    xml.opml(:version => 1.0) do
      xml.head do
        # CHANGE ME
        xml.title 'RSS Reader Subscriptions'
      end
      xml.body do
        @folders.each do |folder|
          xml.outline({
                        :title => folder.name,
                        :text => folder.name,
                      }){
            folder.feeds.each do |feed|
              xml.outline({
                            :type => 'rss',
                            :version => 'RSS',
                            :description => '',
                            :title => feed.title,
                            :htmlUrl => feed.url,
                            :xmlUrl => feed.xml_url
                          })
            end
          }

        end
      end
    end
    send_data @xml,
    :type => 'text/xml',
    :disposition => "attachment; filename=export.xml"
  end

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    @feed = Feed.new
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feed }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: "Feed was successfully deleted" }
      format.json { head :no_content }
    end
  end

  private
  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :url, :xml_url, :feed_type, :last_checked_at)
  end
end
