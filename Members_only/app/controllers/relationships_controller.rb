class RelationshipsController < ApplicationController
  before_action :check_loggedin
  
  def create
    @user = User.find(params[:followed_id])
    curr_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    curr_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
