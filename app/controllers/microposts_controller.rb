class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :having_permission, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @feed_items = current_user.microposts.order(created_at: :desc).
        paginate page: params[:page],
        per_page: Settings.per_page
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def having_permission
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_back_or root_url if @micropost.nil?
  end
end
