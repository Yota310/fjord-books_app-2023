# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /users/sign_in
  def new; end

  # POST /users/sign_in
  def create
    @user = User.find_by(email: params[:session][:email])
    if @user.valid_password?(params[:session][:password])
      sign_in(@user)
      redirect_to '/books'
    else
      render 'new', notice: 'ログインに失敗しました'
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
