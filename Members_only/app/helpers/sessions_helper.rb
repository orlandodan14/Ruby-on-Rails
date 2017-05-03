module SessionsHelper
  
  # Logs in the given user:
  def login(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session:
  def remember(user)
    user.create_remembertoken
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # forgets a persistent session:
  def forget(user)
    user.forget_remembertoken
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Returns the current logged-in user (if any) corresponding to the remember token cookie:
  def curr_user
    if (user_id = session[:user_id])
      @curr_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login(user)
        @curr_user = user
      end
    end
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
  
  # Rediects to stored location or to the default:
  def redirect_back_or(default)
    redirect_to(session[:stored_url] || default)
    session.delete(:stored_url)
  end
  
  # Stores the URL traying to be accessed:
  def store_url
    session[:stored_url] = request.original_url if request.get?
  end
end
