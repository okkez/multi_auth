# -*- coding: utf-8 -*-

# 認証情報コントローラ
class CredentialsController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required

  # GET /credentials
  def index
    @open_id_credentials =
      @login_user.open_id_credentials.all(:order => "open_id_credentials.identity_url ASC")
    @email_credentials =
      @login_user.email_credentials.all(:order => "email_credentials.email ASC")
    @name_credentials = @login_user.name_credentials.all(:order => "name_credentials.name ASC")
  end
end
