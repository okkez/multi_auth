# -*- coding: utf-8 -*-

class MultiAuth

  class << self
    attr_accessor_with_default :application_name, 'app'
    attr_accessor_with_default :from_address, 'noreply@example.com'
    attr_accessor_with_default :user_model, 'User'
    def setup
      yield self
    end

    def self.user_model_class
      @user_model.constantize
    end
  end

  module ClassMethods
    def verify_method_post(options = {})
      verify({
               :method => :post,
               :render => {:text => "Method Not Allowed", :status => 405},
             }.merge(options))
    end
  end

  module InstanceMethods

    private

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
end

ActionController::Base.__send__(:extend, MultiAuth::ClassMethods)
ActionController::Base.__send__(:include, MultiAuth::InstanceMethods)
