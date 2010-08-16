class Auth::NameController < ApplicationController
  filter_parameter_logging :password
  verify_method_post :only => [:login]

  # GET /auth/name
  def index
    session[:user_id] = nil
    @login_form = NameLoginForm.new
  end

  # POST /auth/name/login
  def login
    session[:user_id] = nil
    @login_form = NameLoginForm.new(params[:login_form])

    if @login_form.valid?
      @name_credential = @login_form.authenticate
    end

    if @name_credential
      @name_credential.login!
      @login_user = @name_credential.user
      session[:user_id] = @login_user.id
      redirect_to(:controller => "/auth", :action => "logged_in")
    else
      @login_form.password = nil
      set_error_now(p_("MultiAuth", "The name or the password is wrong."))
      render(:action => "index")
    end
  end
end
