require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  # Defines a user variable using the fixtures.
  def setup
    @user = users(:michael)
    remember(@user)
  end
  
  test "current_user returns right user when session is nil" do
    assert_equal @user, curr_user
    assert loggedin?
  end
  
  test "curr_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil curr_user
  end
end
