class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    if user&.authenticate(params[:password])
      destination = session.delete(:return_to) || root_path
      reset_session
      session[:user_id] = user.id
      redirect_to destination, notice: "Welcome back, #{user.name.split.first}."
    else
      flash.now[:alert] = "Email or password is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "You have been signed out."
  end
end
