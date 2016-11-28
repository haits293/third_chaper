class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.microposts.order(created_at: :desc).
        paginate page: params[:page],
        per_page: Settings.per_page
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
