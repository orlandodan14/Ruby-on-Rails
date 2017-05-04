require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count', 0 do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
  
  test "valid sugnup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example Test user",
                                         email: "user@valid.com",
                                         password: "valid_password",
                                         password_confirmation: "valid_password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    login_as(user) # Try to log in before activation.
    assert_not loggedin?
    get edit_account_activation_path("invalid token", email: user.email) # Invalid activation token
    assert_not loggedin?
    get edit_account_activation_path(user.activation_token, email: 'wrong') # Valid token, wrong email
    assert_not loggedin?
    get edit_account_activation_path(user.activation_token, email: user.email) # Valid activation token
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert loggedin?
  end
end
