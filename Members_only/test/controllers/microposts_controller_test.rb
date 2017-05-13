require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @micropost = microposts(:first)
  end
  
  test "should reditect creat when not logged in" do
    assert_no_difference 'Micropost.count', 0 do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count', 0 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy from wrong micropost" do
    login_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count', 0 do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
