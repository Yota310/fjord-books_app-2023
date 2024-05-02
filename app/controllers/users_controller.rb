# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @users = User.all
  end

  def show; end

  def set_user
    @user = User.find(params[:id])
  end
end
