module Admin::ApplicationHelper
  def user_role_name(admin)
    admin ? '管理ユーザー' : '一般ユーザー'
  end
end
