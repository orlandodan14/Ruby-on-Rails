module SessionsHelper
  
  # Logs in the given user:
  def login(user)
    session[:user_id] = user.id
  end
  
  # Returns the current logged-in user (if any):
  def curr_user
    @curr_user ||= User.find_by(id: session[:user_id])
  end
  
  # Returns true if the user is logged-in, false otherwise:
  def loggedin?
    !curr_user.nil?
  end
  
  # Logs out the current user:
  def logout
    session.delete(:user_id)
    @curr_user = nil
  end  
end
