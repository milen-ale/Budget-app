class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_devise_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(_resource)
    budget_categories_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  private

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
