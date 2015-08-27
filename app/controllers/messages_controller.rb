class MessagesController < ApplicationController
  skip_before_action :restrict_access, only: [:create]

  def index
    @messages = current_user.messages.by_user(params[:user_id])
  end

  def create
    # head :not_found and return unless request.local?

    @message = Message.new(message_params)
    if @message.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def clean_up
    current_user.messages.destroy_all
    head :no_content
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id, :creator_id)
  end
end
