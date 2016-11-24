class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]
    if user.active?
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        flash[:success] = "Hello #{user.name}"
        redirect_back_or user
      else
        flash[:danger] = "Invalid email/password combination"
        render :new
      end
    else
      flash[:danger] = "This account has been suspended.
        Please contact the administrator. Thank you."
      redirect_to login_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
