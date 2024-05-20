# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.order(id: 'ASC').page(params[:page])
  end

  def show
    @user = current_user
    @comment = Comment.new
    @comments = @report.comments
    set_comment_users
  end

  def new
    @report = Report.new
  end

  def edit
    if current_user.name == @report.user
      render 'edit'
    else
      redirect_to reports_path
    end
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
    else
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  def update
    if @report.update(report_params)
      format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
    else
      format.html { render :edit, status: :unprocessable_entity }
    end
  end

  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content, :user_id).merge(user_id: current_user.id)
  end

  def set_comment_users
    @users = @comments.map do |comment|
      User.where("id = #{comment.user_id}")[0]
    end
  end
end
