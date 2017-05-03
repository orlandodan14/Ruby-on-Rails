class UsersController < ApplicationController
  before_action :check_loggedin,     only: [:index, :edit, :update, :destroy]
  before_action :check_correct_user, only: [:edit, :update]
  before_action :admin_user,         only: :destroy
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      flash[:success] = "Hi, #{@user.name}, Welcome to the Members Only App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  # PRIVATE METHODS:
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  # BEFORE ACTIONS:
  # Confirms a logged-in user:
  def check_loggedin
    unless loggedin?
      store_url
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  # Confirms the correct user.
  def check_correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless @user == curr_user
  end
  
  # Confirms an admin user:
  def admin_user
    redirect_to(root_url) unless curr_user.admin?
  end
end
