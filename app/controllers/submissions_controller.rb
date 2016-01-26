class SubmissionsController < ApplicationController
  before_action :set_event, only: [:index, :create]
  before_action :set_submission, only: [:update, :destroy, :decline]

  def index
    authorize @event, :submissions?
    @submissions = @event.submissions
  end

  def create
    @submission = @event.submissions.build(user: current_user)

    if @submission.save
      render :show, status: :created
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

  def decline
    authorize @submission
    @submission.decline
    head :ok
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_submission
    @submission = Submission.find(params[:id])
  end
end
