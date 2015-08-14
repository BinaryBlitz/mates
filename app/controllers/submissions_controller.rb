class SubmissionsController < ApplicationController
  before_action :set_submission, except: [:index, :create]

  def index
    @submissions = current_user.submissions
  end

  def show
  end

  def create
    @submission = current_user.submissions.build(submission_params)

    if @submission.save
      render :show, status: :created, location: @submission
    else
      render json: @submission.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @submission
    @submission.accept
    head :no_content
  end

  def destroy
    authorize @submission
    @submission.destroy
    head :no_content
  end

  private

  def set_submission
    @submission = Submission.find(params[:id])
  end

  def submission_params
    params.permit(:event_id)
  end
end
