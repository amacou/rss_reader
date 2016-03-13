class SubscriptionsController < ApplicationController
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

    respond_to do |format|
      if subscription.persisted?
        format.html { redirect_to subscriptions_url, notice: 'rss feed was successfully add.' }
        format.json { head :no_content }
      else
        format.html { redirect_to subscriptions_url, notice: 'rss feed was faild to add' }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
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

  # GET /subscriptions
  # GET /subscriptions.json
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

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subscription }
      else
        format.html { render action: 'new' }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:user_id, :feed_id, :folder_id)
    end
end
