# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  # def new
  #   @user = User.new
  # end

  # def create
  #   @user = User.new(user_params)

  #   if @user.save
  #     redirect_to root_url, notice: 'Add User'
  #   else
  #     render :new
  #   end
  # end

  # private

  # def user_params
  #   params.fetch(:user, {}).permit(:name, :avatar)
  # end
end
