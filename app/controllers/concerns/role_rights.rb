module RoleRights
  extend ActiveSupport::Concern

  class PermissionError < StandardError; end

  def require_admin_authority
    raise PermissionError, 'login permission denied' unless current_user&.admin
  end
end
