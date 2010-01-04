# -*- coding: utf-8 -*-

module MultiAuth
  module ActionController
    module ClassMethods
      def verify_method_post(options = {})
        verify({
                 :method => :post,
                 :render => {:text => "Method Not Allowed", :status => 405},
               }.merge(options))
      end
    end
    module InstanceMethods

      def self.included(base)
        base.class_eval{
          init_gettext("multi_auth",
                       :locale_path => MultiAuth.root + 'locale')
        }
      end

      private

      def authentication(user_id = session[:user_id])
        @login_user = MultiAuth.user_model_class.find_by_id(user_id)
        return true
      end

      def authentication_required
        if session[:expires_at]
          if session_expired?
            logger.info "[MultiAuth] Session has expired, resetting session"
            reset_login_session
            set_error("Session has expired. Please login again.")
            return false
          end
          update_session_expiry
        end

        if @login_user
          return true
        else
          set_error("ログインが必要です。")
          redirect_to(root_path)
          return false
        end
      end

      def update_session_expiry
        return unless MultiAuth.session_times_out_in
        session[:expires_at] = Time.now + MultiAuth.session_times_out_in
      end

      def session_expired?
        Time.now > session[:expires_at]
      end

      def reset_login_session
        session[:user_id] = nil
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
end

