
require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  [
   [:get,  "/auth",            "index"],
   [:get,  "/auth/logged_in",  "logged_in"],
   [:post, "/auth/logout",     "logout"],
   [:get,  "/auth/logged_out", "logged_out"]
  ].each do |method, path, action|
    test "routes #{method} #{path}" do
      base = {:controller => "auth"}
      assert_routing({ :method => method, :path => path }, base.merge(:action => action))
    end
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end

  test "GET logged_in" do
    return_path = "/return"

    get :logged_in, :return_path => return_path

    assert_response(:success)
    assert_template("logged_in")

    assert_equal(return_path, assigns(:return_path))
  end

  test "GET logged_in, without return path" do
    get :logged_in

    assert_response(:success)
    assert_template("logged_in")

    assert_equal(root_path, assigns(:return_path))
  end

  test "POST logout" do
    @request.session[:user_id] = 0

    post :logout

    assert_response(:redirect)
    assert_redirected_to(:controller => "auth", :action => "logged_out")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET logout, abnormal, method not allowed" do
    @request.session[:user_id] = 0

    get :logout

    assert_response(405)
    assert_template(nil)

    assert_equal(0, @request.session[:user_id])
  end

  test "GET logged_out" do
    return_path = "/return"

    get :logged_out, :return_path => return_path

    assert_response(:success)
    assert_template("logged_out")

    assert_equal(return_path, assigns(:return_path))
  end

  test "GET logged_out, without return path" do
    get :logged_out

    assert_response(:success)
    assert_template("logged_out")

    assert_equal(root_path, assigns(:return_path))
  end
end
