class ApplicationController < ActionController::Base
  include SessionControl
  include Banken

  before_action :require_logged_in
  before_action -> { current_user&.periodical_alarm_update }

  after_action :verify_authorized
end
