class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @attempt = Survey::Attempt.where(participant_id: params[:id])

  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Successfully registerd for app!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  def change_name
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to :back
  end
  private
  def user_params
    params.require(:user).permit(:lastname,:name, :email, :password,
                                 :password_confirmation,:admin)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to (root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


end
