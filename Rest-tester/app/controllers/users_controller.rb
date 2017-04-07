class UsersController < ApplicationController
  
  def index
    @name = "I am the INDEX action!"
  end
  
  def show
    @name = "I am the SHOW action!"
  end
  
  
  def new
    @name = "I am the NEW action!"
  end
  
  
  def edit
    @name = "I am the EDIT action!"
  end
  
  def create
    @name = "I am the CREATE action!"
  end
end
