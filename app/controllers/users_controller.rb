class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username].downcase)
    @discussions = @user.discussions.fresh.limit(20)
  end
end
