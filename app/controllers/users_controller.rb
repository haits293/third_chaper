class UsersController < ApplicationController
  before_action :logged_in_user, except: [:destroy, :new, :create]
  before_action :verify_admin, only: :destroy
  before_action :find_user, except: [:index, :new, :create]

  def index
    @users = User.activated.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    unless have_permission?
      flash[:danger] = "Permission denied."
      redirect_back_or root_url
    end
  end

  def update
    if have_permission?
      if @user.active?
        if @user.update_attributes user_params
          flash[:success] = "Profile updated"
          redirect_to @user
        else
          render :edit
        end
      elsif @user.deleted?
        @user.update_attributes status: 0
        flash[:success] = "User reactivated"
        redirect_to :back
      end
    else
      flash[:danger] = "Not permisson"
      redirect_to root_url
    end
  end

  def destroy
    if @user.nil?
      flash[:danger] = "This user does not exist"
      redirect_to users_path
    else
      @user.update_attributes status: 1
      flash[:success] = "User deleted"
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation, :date_of_birth
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = "Don't find user"
      redirect_to root_url
    end
  end

  def have_permission?
    current_user.is_admin? || current_user == @user
  end
end
