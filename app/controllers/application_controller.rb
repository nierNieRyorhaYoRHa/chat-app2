class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

  end


end


# authenticate_user!
# deviseに実装されているメソッドです。コントローラーに設定することで、ログイン済ユーザーのみにアクセスを許可し、ログインをしていないユーザーはログイン画面に遷移させます。






