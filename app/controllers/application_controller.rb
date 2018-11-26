class ApplicationController < ActionController::Base
  include SessionControl

  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  before_action :require_logged_in
  before_action -> { current_user&.update_delayed_tasks_alarm }
end
