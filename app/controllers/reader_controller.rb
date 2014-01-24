# -*- coding: utf-8 -*-
class ReaderController < ApplicationController
  before_filter :authenticate
  layout 'reader'
  def index
    prev_weight = params[:t]
    @entries = Entry.joins(:unread_entries).where(['unread_entries.user_id=?',current_user.id]).where(['unread_entries.readed=?',false]).includes(:feed).order("unread_entries.weight #{current_user.sort_type}")
    if prev_weight
      if current_user.sort_type == User::SORT_TYPE_DESC
        @entries = @entries.where(['unread_entries.weight < ? ',prev_weight])
      else
        @entries = @entries.where(['unread_entries.weight > ? ',prev_weight])
      end
    end
    @entries = @entries.page(1).per(20)
  end

  def readed
    UnreadEntry.where(user_id: current_user.id, entry_id: params[:id]).limit(1).update_all(readed: true)
    render :nothing => true
  end
end
