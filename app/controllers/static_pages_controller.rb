class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed1_items = current_user.feed1.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end
