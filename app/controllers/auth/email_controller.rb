# -*- coding: utf-8 -*-

# メール認証
class Auth::EmailController < ApplicationController
  filter_parameter_logging :password
  verify_method_post :only => [:login]

  # GET /auth/email
  def index
    session[:user_id] = nil
    @login_form = EmailLoginForm.new
  end

  # POST /auth/email/login
  def login
    session[:user_id] = nil
    @login_form = EmailLoginForm.new(params[:login_form])

    if @login_form.valid?
      @email_credential = @login_form.authenticate
    end

    if @email_credential
      @email_credential.login!
      @login_user = @email_credential.user
      session[:user_id] = @login_user.id
      redirect_to(:controller => "/auth", :action => "logged_in")
    else
      @login_form.password = nil
      set_error_now(p_("MultiAuth", "The email address or the password is wrong."))
      render(:action => "index")
    end
  end
end
