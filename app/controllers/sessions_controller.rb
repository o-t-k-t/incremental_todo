class SessionsController < ApplicationController
  include SessionControl

  before_action :require_logged_in, except: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user_path(user.id)
    else
      flash.now[:alert] = 'Eメールアドレスかパスワードが不正です'
      render :new
    end
  end

  def destroy
    log_out
    flash.now[:alert] = 'ログアウトしました'
    redirect_to new_session_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
