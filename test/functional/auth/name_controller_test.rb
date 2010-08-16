require 'test_helper'

class Auth::NameControllerTest < ActionController::TestCase
  def setup
    @login_form = NameLoginForm.new
  end

  test "toutes" do
    base = { :controller => "auth/name" }

    assert_routing("/auth/name",       base.merge(:action => "index"))
    assert_routing("/auth/name/login", base.merge(:action => "login"))
  end

  test "GET index" do
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(NameLoginForm.new.attributes, assigns(:login_form).attributes)
  end

  test "POST login" do
    session_login(users(:shinya))

    time = Time.local(2010, 1, 1)
    @login_form.attributes = {
      :name     => name_credentials(:nayutaya).name,
      :password => "nayutaya",
    }
    assert_equal(true, @login_form.valid?)

    Kagemusha::DateTime.at(time) {
      post :login, :login_form => @login_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/auth", :action => "logged_in")
    assert_flash_empty
    assert_logged_in(users(:yuya))

    assert_equal(
      @login_form.attributes,
      assigns(:login_form).attributes)

    assert_equal(name_credentials(:nayutaya), assigns(:name_credential))
    assert_equal(time, assigns(:name_credential).loggedin_at)
  end

  test "POST login, invalid form" do
    session_login(users(:shinya))

    assert_equal(false, @login_form.valid?)

    post :login, :login_form => @login_form.attributes

    assert_response(:success)
    assert_template("index")
    assert_flash_error
    assert_not_logged_in

    assert_equal(nil, assigns(:login_form).password)
    assert_equal(nil, assigns(:email_credential))
  end

  test "GET login, abnormal, method not allowed" do
    get :login

    assert_response(405)
    assert_template(nil)
  end
end
