class Admin::ApplicationController < ApplicationController
  include RoleRights

  before_action :require_admin_authority
end
