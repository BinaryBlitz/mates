class ProposalsController < ApplicationController
  before_action :set_event, only: [:index, :create]
  before_action :set_proposal, only: [:update, :destroy]

  def index
    authorize @event, :proposals?
    @proposals = @event.proposals
  end

  def create
    @proposal = @event.proposals.build(proposal_params)
    @proposal.creator = current_user
    authorize @proposal

    if @proposal.save
      render :show, status: :created
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @proposal
    @invite = @proposal.accept
    head :ok
  end

  def destroy
    authorize @proposal
    @proposal.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:user_id)
  end
end
