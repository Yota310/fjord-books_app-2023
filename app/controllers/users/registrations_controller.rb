# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    redirect_to '/books' if current_user
    @user = User.new
  end

  # POST /resource
  def create
    @user = User.new(create_users_params)
    if @user.save
      sign_in(@user)
      redirect_to '/books'
    else
      render 'new'
    end
  end

  # GET /resource/edit
  def edit
    @user = current_user
  end

  # PUT /resource
  def update
    @user = current_user
    # アップデートする内容と画面遷移のリダイレクトを追加する
    respond_to do |format|
      if @user.update(update_users_params)
        format.html { redirect_to "/users/#{@user[:id]}/show", notice: t('controllers.common.notice_update', name: User.model_name.human) }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private

  def create_users_params
    params.require(:user).permit(:name, :email, :password)
  end

  def update_users_params
    params.require(:user).permit(:name, :email, :profile, :address, :postcode)
  end

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
end
