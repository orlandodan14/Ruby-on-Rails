class MicropostsController < ApplicationController
  before_action :check_loggedin, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = curr_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'microposts/index'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  def index
    if loggedin?
      @micropost = curr_user.microposts.build
      @feed_items = curr_user.feed.paginate(page: params[:page])
    end
  end
  
  # PRIVATE METHODS:
  private
  
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    # Checks that the current user actually has a micropost with the given id:
    def correct_user
      @micropost = curr_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
