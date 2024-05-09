# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all.order(:id).page(params[:page]).per(2)
  end

  def show; end

  def set_user
    @user = User.find(params[:id])
  end
end
