class ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :update, :destroy]

  def show
  end

  # Propose user
  def create
    @proposal = Proposal.new(proposal_params)
    @proposal.creator = current_user

    if @proposal.save
      render :show, status: :created, location: @proposal
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  # Accept the proposal
  def update
    @proposal.accept
    head :no_content
  end

  # Decline or cancel proposal
  def destroy
    @proposal.destroy
    head :no_content
  end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:user_id, :event_id)
  end
end
