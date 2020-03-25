class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :admin_user,     only: :destroy


  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "EVENT created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "EVENT deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    #This portion works fine but not on Admin user
    #def correct_user
     # @micropost = current_user.microposts.find_by(id: params[:id])
      #redirect_to root_url if @micropost.nil?
    #end


    #This portion works fine, also on Admin user
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      if @micropost.nil? && current_user.admin?
        @micropost = Micropost.find_by(id: params[:id])
      end

      redirect_to root_url if @micropost.nil?
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
