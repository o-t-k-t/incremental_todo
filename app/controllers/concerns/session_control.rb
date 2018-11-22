module SessionControl
  extend ActiveSupport::Concern

  private

  def log_in(user)
    session[:user_id] = user.id
    flash[:notice] = "#{user.name}さんとしてログインしました😃"
  end

  def log_out
    session.delete(:user_id)
  end

  def require_logged_in
    redirect_to new_session_path, notice: 'ログインしましょう😀' unless logged_in?
  end

  included do
    helper_method :logged_in?, :current_user, :current_user

    def logged_in?
      current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def current_user?(user_id)
      current_user&.id.eql?(user_id.to_i)
    end
  end
end
