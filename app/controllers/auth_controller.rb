# -*- coding: utf-8 -*-

# 認証
class AuthController < ApplicationController
  verify_method_post :only => [:logout]

  # GET /auth/logged_in
  def logged_in
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end

  # POST /auth/logout
  def logout
    reset_session
    redirect_to(:action => "logged_out")
  end

  # GET /auth/logged_out
  def logged_out
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end
end
