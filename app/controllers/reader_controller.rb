# -*- coding: utf-8 -*-
class ReaderController < ApplicationController
  before_filter :authenticate

  layout 'reader'

  def index
    @entries = current_user.entries.unread.order("unread_entries.weight #{current_user.sort_type}").includes(:feed)

    if prev_weight = params[:t]
      if current_user.sort_type == User::SORT_TYPE_DESC
        @entries = @entries.where(['unread_entries.weight < ? ',prev_weight])
      else
        @entries = @entries.where(['unread_entries.weight > ? ',prev_weight])
      end
    end
    @entries = @entries.page(1).per(20)
  end

  def readed
    current_user.unread_entries.where(entry_id: params[:id]).limit(1).update_all(readed: true)
    render :nothing => true
  end
end
