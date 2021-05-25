class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :edit, :update, :destroy]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new

  end

  def edit
    @user = User.find(params[:id])
    unless (current_user ==  @user) || isadmin?
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])

    unless (current_user ==  @user) || isadmin?
      redirect_to root_path
    end

    if @user.update(user_params)
      flash[:success] = 'ユーザプロフィールを更新しました。'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger] = 'ユーザプロフィールの更新に失敗しました。'
      render :update
    end

  end

  def destroy
    @user = User.find(params[:id])
    unless (current_user ==  @user) || isadmin?
      redirect_to root_path
    end

    @user.destroy
    flash[:success] = '退会しました。'
    redirect_to root_path

  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def likes
    @user = User.find(params[:id])
    @favorite_microposts = @user.favorite_microposts.page(params[:page])
    counts(@user)
  end

  private
  
  def user_params
    if isadmin?
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :age, :profile, :privilege)
    else
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :age, :profile)
    end
  end

end
