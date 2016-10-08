class SubscriptionsController < ApplicationController
  layout 'setting'
  before_filter :authenticate
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  def change_folder
    id = params[:change_folder_to]
    subscription_ids = params[:subscriptions]
    id = nil if id == 'no-folder'
    subscription_table = Subscription.arel_table
    if id.nil? || current_user.folders.where(id:id).first
      subscriptions = current_user.subscriptions.where(subscription_table[:id].in(subscription_ids))
      subscriptions.each do |subscription|
        subscription.folder_id = id
        subscription.save
      end
    end

    redirect_to subscriptions_url, :notice => "Folder Successfully Changed"
  end

  def subscribe
    url = params[:url]
    subscription = current_user.subscriptions.joins(:feed).where('feeds.url' => url).first
    unless subscription
      subscription = current_user.subscriptions.build unless subscription
      if feed = Feed.subscribe_from_url(url)
        subscription.feed = feed
        subscription.load_unread_entry if subscription.save
      end
    end

    if subscription.persisted?
      redirect_to subscriptions_url, notice: 'rss feed was successfully add.'
    else
      redirect_to subscriptions_url, notice: 'rss feed was faild to add'
    end
  end

  def unsubscribe
    subscription_table = Subscription.arel_table
    subscription_ids = params[:subscriptions]
    @subscriptions = current_user.subscriptions.where(subscription_table[:id].in(subscription_ids))
    @subscriptions.each do |subscription|
      subscription.destroy
    end
    redirect_to subscriptions_url, :notice => "Unsubscribe Successffly"
  end

  def index
    @folders = current_user.folders.all
    @subscriptions = current_user.subscriptions.includes(:feed, :folder)
    page = params[:page]
    page ||= 1

    if params[:folder]
      @subscriptions = @subscriptions.where(folder_id: params[:folder])
    end
    @subscriptions = @subscriptions.page(page).per(100)
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def edit
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      redirect_to @subscription, notice: 'Subscription was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to @subscription, notice: 'Subscription was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @subscription.destroy
    redirect_to subscriptions_url
  end

  private
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :feed_id, :folder_id)
  end
end
