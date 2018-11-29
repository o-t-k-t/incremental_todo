class SessionsController < ApplicationController
  skip_before_action :require_logged_in, only: %i[new create]

  def new
    authorize!
  end

  def create
    authorize!

    user = User.authenticate_by(params[:session][:email],
                                params[:session][:password])
    if user
      log_in(user)
      redirect_to user_path
    else
      flash.now[:alert] = I18n.t('sessions.login_fail')
      render :new
    end
  end

  def destroy
    authorize!

    log_out
    flash.now[:alert] = I18n.t('sessions.logout')
    redirect_to new_session_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
