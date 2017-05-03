require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    login_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "invalid@email",
                                              password: "valid",
                                              password_confirmation: "invalid" } }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    login_as(@user)  
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "Some name",
                                              email: "valid@email.com",
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Some name", @user.name
    assert_equal "valid@email.com", @user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    login_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Some Valid Name"
    email = "some@valid.email"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
