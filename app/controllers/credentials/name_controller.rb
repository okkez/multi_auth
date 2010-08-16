# -*- coding: utf-8 -*-
class Credentials::NameController < ApplicationController

  verify_method_post :only => [:create, :update_password, :destroy, :activate]
  before_filter :authentication
  before_filter :authentication_required
  before_filter :required_param_name_credential_id, :only => [:edit_password, :update_password, :delete, :destroy]
  before_filter :specified_name_credential_belongs_to_login_user, :only => [:edit_password, :update_password, :delete, :destroy]

  # GET /credentials/name/new
  def new
    @edit_form = NameCredentialEditForm.new
  end

  # POST /credentials/name/create
  def create
    @edit_form = NameCredentialEditForm.new(params[:edit_form])

    @name_credential = @login_user.name_credentials.build
    @name_credential.attributes = @edit_form.to_name_credential_hash

    if @edit_form.valid? && @name_credential.save
      # メール送信はしない
      set_notice(p_("MultiAuth", "Name authentication credential was successfully added."))
      redirect_to(credentials_path)
    else
      @edit_form.password              = nil
      @edit_form.password_confirmation = nil
      set_error_now(p_("MultiAuth", "Please confirm your input."))
      render(:action => "new")
    end
  end

  # GET /credential/name/:name_credential_id/edit_password
  def edit_password
    @edit_form = PasswordEditForm.new
  end

  # POST /credential/name/:name_credential_id/update_password
  def update_password
    @edit_form = PasswordEditForm.new(params[:edit_form])

    @name_credential.attributes = @edit_form.to_credential_hash

    if @edit_form.valid? && @name_credential.save
      set_notice(p_("MultiAuth", "Password was changed."))
      redirect_to(:controller => "/credentials")
    else
      @edit_form.password              = nil
      @edit_form.password_confirmation = nil
      set_error_now(p_("MultiAuth", "Please confirm your input."))
      render(:action => "edit_password")
    end
  end

  # GET /credential/name/:name_credential_id/delete
  def delete
    # nop
  end

  # POST /credential/email/:email_credential_id/destroy
  def destroy
    @name_credential.destroy

    set_notice(p_("MultiAuth", "Name authentication credential was successfully deleted."))
    redirect_to(:controller => "/credentials")
  end

  private

  # FIXME: login_userに属することを同時に確認
  def required_param_name_credential_id(name_credential_id = params[:name_credential_id])
    @name_credential = NameCredential.find_by_id(name_credential_id)
    if @name_credential
      return true
    else
      set_error(p_("MultiAuth", "It is invalid name authentication credential."))
      redirect_to(root_path)
      return false
    end
  end

  def specified_name_credential_belongs_to_login_user
    if @name_credential.user_id == @login_user.id
      return true
    else
      set_error(p_("MultiAuth", "It is invalid name authentication credential."))
      redirect_to(root_path)
      return false
    end
  end

end
