require "test_helper"

class CreateUserTest < ActionDispatch::IntegrationTest

  test "get signup form and create a new user" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "tiffany", email: "tiffany@email.com", password: "password"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "tiffany", response.body
  end
 
  test "get new user and reject invalid username" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "ti", email: "tiffany@email.com", password: "password"} }
    end
    assert_match "Username is too short", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
 
  test "get new user and reject blank password" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "tiffany2", email: "tiffany2@email.com", password: ""} }
    end
    assert_match "blank", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
 
  test "get new user and reject existing email address" do
    User.create(username: "tiffany3", email: "tiffany3@email.com", password: "password")
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "tiffany4", email: "tiffany3@email.com", password: "password"} }
    end
    assert_match "been taken", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
