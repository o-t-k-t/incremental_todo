class Admin::ApplicationController < ApplicationController
  include SessionControl
  include RoleRights

  before_action :require_logged_in
  before_action :require_admin_authority
end
