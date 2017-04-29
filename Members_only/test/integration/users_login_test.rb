require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
    
  # Return a new user based on fixtures/users.yml:
  def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "invalid@email", password: "no" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
   
  test "login with valid information" do
    get login_path # Visit the login path.
    post login_path, params: { session: { email: @user.email, # Post valid information to the sessions path.
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # Verify that the login link disappears.
    assert_select "a[href=?]", user_path(@user) # Verify that a profile link appears.
    assert_select "a[href=?]", logout_path # Verify that a logout link appears.
  end
  
  test "login with valid information followed by logout" do    
    get login_path # Visit the login path.
    post login_path, params: { session: { email: @user.email, # Post valid information to the sessions path.
                                          password: 'password' } }
    assert loggedin? # Verify that a user is logged-in.
    assert_redirected_to @user 
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # Verify that the login link disappears.
    assert_select "a[href=?]", user_path(@user) # Verify that a profile link appears.
    assert_select "a[href=?]", logout_path # Verify that a logout link appears.
    delete logout_path
    assert_not loggedin? # Verify that a user is logged-out.
    assert_redirected_to root_url
    follow_redirect!    
    assert_select "a[href=?]", login_path # Verify that the login link appears.
    assert_select "a[href=?]", logout_path,      count: 0 # Verify that a profile link disappears.
    assert_select "a[href=?]", user_path(@user), count: 0 # Verify that a logout link disappears.
  end
end
