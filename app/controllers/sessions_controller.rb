class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      if user.active?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        flash[:success] = "Hello #{user.name}"
        redirect_back_or root_path
      elsif user.inactive?
        message  = "Account not activated.
          Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      else
        flash[:danger] = "This account has been suspended.
          Please contact the administrator. Thank you."
        redirect_to login_path
      end
    else
      flash[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
