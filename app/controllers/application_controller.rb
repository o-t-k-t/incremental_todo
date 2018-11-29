class ApplicationController < ActionController::Base
  include SessionControl
  include Banken

  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'production'

  before_action :require_logged_in
  before_action -> { current_user&.periodical_alarm_update }

  after_action :verify_authorized
end
