class InterestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @interests = current_user.interests.includes(:category)
  end

  def update_all
    @form = FunnyVideos::Interests::UpdateAllForm.new(current_user)
    @form.submit(params[:interests])
    flash[:notice] = "success"
    redirect_to action: "index"
  end
end
