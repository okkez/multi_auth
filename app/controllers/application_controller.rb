# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter { |c| c.instance_eval { @topic_path = [] }; true }

  GetText.locale = "ja"
  init_gettext "multi_auth"

  private

  def self.verify_method_post(options = {})
    verify({
      :method => :post,
      :render => {:text => "Method Not Allowed", :status => 405},
    }.merge(options))
  end

  def authentication(user_id = session[:user_id])
    @login_user = User.find_by_id(user_id)
    return true
  end

  def authentication_required
    if @login_user
      return true
    else
      set_error("ログインが必要です。")
      redirect_to(root_path)
      return false
    end
  end

  def set_notice(message)
    flash[:notice] = @flash_notice = message
    flash[:error]  = @flash_error  = nil
  end

  def set_error(message)
    flash[:notice] = @flash_notice = nil
    flash[:error]  = @flash_error  = message
  end

  def set_error_now(message)
    flash.now[:notice] = @flash_notice = nil
    flash.now[:error]  = @flash_error  = message
  end

end
