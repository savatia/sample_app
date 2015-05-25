class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		#handle
  		log_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    # we do not need to assign @user here
    # @user = User.find(params[:id])
  end

  def update 
    # we do not need to assign @user here
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #handle a successful update
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # before_action filters

  #confirms logged in user
  def logged_in_user
    unless logged_in?
        store_location
      flash[:danger] = "Please log in!"
      redirect_to login_url
    end
  end

  # cofirms the correct user
  def correct_user
    # we have defined @user here
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  private
    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
