class ReportsController < ApplicationController
  def create
    @report = Report.new(report_params)

    if @report.save
      render json: @report, status: :created
    else
      render json: @report.errors, status: 422
    end
  end

  private

  def report_params
    params.require(:report).permit(:content, :user_id, :event_id)
  end
end
