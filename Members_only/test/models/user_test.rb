require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example Test user", email: "user_test@example.com",
                     password: "password_test", password_confirmation: "password_test")
  end
  
  test "user should be valid" do
    assert @user.valid?
  end
  
  test "user name should be valid" do
    @user.name = "    "
    assert_not @user.valid?
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "user email should be valid" do
    # Blanck email:
    @user.email = "    "
    assert_not @user.valid?
    # Email too long:
    @user.email = "a" * 50 + "@example.com"
    assert_not @user.valid?
    # Valid emails:
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end
    # Invalid emails:
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
    end
  end
  
  test "email address should be valid" do    
    other_user = @user.dup
    @user.save
    assert_not other_user.valid?
    other_user.email = @user.email.upcase
    assert_not other_user.valid?
    # Email should be lower-case:
    @user.email = "UseR_TesT@ExAMPle.CoM"
    assert_equal @user.email.downcase, @user.reload.email
  end
  
  test "password should be valid" do
    # password should be nonblanck:
    @user.password = @user.password_confirmation = "     "
    assert_not @user.valid?
    # Passwrod should has the correct length:
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?("")
  end
end
