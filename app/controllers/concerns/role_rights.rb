module RoleRights
  extend ActiveSupport::Concern

  class PermissionError < StandardError; end

  included do
    rescue_from PermissionError, with: :render_403 unless Rails.env == 'development'
  end

  def require_admin_authority
    raise PermissionError, 'login permission denied' unless current_user&.admin
  end

  private

  def render_403(_exception)
    render file: "#{Rails.root}/public/403.html", layout: false, status: 403
  end
end
