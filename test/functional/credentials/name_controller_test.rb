# -*- coding: utf-8 -*-
require 'test_helper'

class Credentials::NameControllerTest < ActionController::TestCase
  def setup
    @yuya      = users(:yuya)
    @nayutaya  = name_credentials(:nayutaya)
    @risa_risa = name_credentials(:risa_risa)

    @edit_form = NameCredentialEditForm.new(
      :name                  => "name",
      :password              => "password",
      :password_confirmation => "password")

    @password_edit_form = PasswordEditForm.new(
      :password              => "password",
      :password_confirmation => "password")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/name"}

    assert_routing("/credentials/name/new",    base.merge(:action => "new"))
    assert_routing("/credentials/name/create", base.merge(:action => "create"))

    assert_routing("/credential/name/1234567890/edit_password",   base.merge(:action => "edit_password",   :name_credential_id => "1234567890"))
    assert_routing("/credential/name/1234567890/update_password", base.merge(:action => "update_password", :name_credential_id => "1234567890"))
    assert_routing("/credential/name/1234567890/delete",          base.merge(:action => "delete",          :name_credential_id => "1234567890"))
    assert_routing("/credential/name/1234567890/destroy",         base.merge(:action => "destroy",         :name_credential_id => "1234567890"))
  end

  test "GET new" do
    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      NameCredentialEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("NameCredential.count", +1) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)
    assert_equal(@edit_form.attributes, assigns(:edit_form).attributes)
    assigns(:name_credential).reload
    assert_equal(@yuya.id, assigns(:name_credential).user_id)
    assert_equal(@edit_form.name, assigns(:name_credential).name)
    assert_equal(true, NameCredential.compare_hashed_password(@edit_form.password, assigns(:name_credential).hashed_password))
  end

  test "POST create, invalid form" do
    @edit_form.name = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("NameCredential.count", 0) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(nil, assigns(:edit_form).password)
    assert_equal(nil, assigns(:edit_form).password_confirmation)
  end

  test "GET create, abnormal, method not allowed" do
    get :create

    assert_response(405)
    assert_template(nil)
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password" do
    get :edit_password, :name_credential_id => @nayutaya.id

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@nayutaya, assigns(:name_credential))

    assert_equal(PasswordEditForm.new.attributes, assigns(:edit_form).attributes)
  end

  test "GET edit_password, abnormal, no login" do
    session_logout

    get :edit_password, :name_credential_id => @nayutaya.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password, abnormal, invalid name credential id" do
    get :edit_password, :name_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password, abnormal, other's name credential" do
    get :edit_password, :name_credential_id => @risa_risa.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password" do
    assert_equal(true, @password_edit_form.valid?)

    post :update_password, :name_credential_id => @nayutaya.id, :edit_form => @password_edit_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@nayutaya, assigns(:name_credential))

    assert_equal(
      @password_edit_form.attributes,
      assigns(:edit_form).attributes)

    assigns(:name_credential).reload
    assert_equal(
      true,
      NameCredential.compare_hashed_password(@password_edit_form.password, assigns(:name_credential).hashed_password))
  end

  test "POST update_password, invalid form" do
    @password_edit_form.password = "x"
    assert_equal(false, @password_edit_form.valid?)

    post :update_password, :name_credential_id => @nayutaya.id, :edit_form => @password_edit_form.attributes

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_error

    assert_equal(nil, assigns(:edit_form).password)
    assert_equal(nil, assigns(:edit_form).password_confirmation)
  end

  test "GET update_password, abnormal, method not allowed" do
    get :update_password, :name_credential_id => @nayutaya.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST update_password, abnormal, no login" do
    session_logout

    post :update_password, :name_credential_id => @nayutaya.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password, abnormal, invalid name credential id" do
    post :update_password, :name_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :name_credential_id => @nayutaya.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@nayutaya, assigns(:name_credential))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete, :name_credential_id => @nayutaya.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid name credential id" do
    get :delete, :name_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's name credential" do
    get :delete, :name_credential_id => @risa_risa.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("NameCredential.count", -1) {
      post :destroy, :name_credential_id => @nayutaya.id
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@nayutaya, assigns(:name_credential))

    assert_equal(nil, NameCredential.find_by_id(@nayutaya.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy, :name_credential_id => @nayutaya.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy, :name_credential_id => @nayutaya.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid name credential id" do
    post :destroy, :name_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's name credential" do
    post :destroy, :name_credential_id => @risa_risa.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
