# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @reports = Report.order(id: 'DESC').page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comment = Comment.new
    @comments = @report.comments
  end

  def new
    @report = Report.new
  end

  def edit
    @report = current_user.reports.find(params[:id])
    render 'reports/edit'
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if current_user.reports.find(params[:id]).update(report_params)
      redirect_to report_url(params[:id]), notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.reports.find(params[:id]).destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content).merge(user_id: current_user.id)
  end
end
