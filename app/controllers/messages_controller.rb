class MessagesController < ApplicationController
  skip_before_action :restrict_access, only: [:create]

  def index
    @messages = current_user.messages
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

  private

  def message_params
    params.require(:message).permit(:content, :user_id, :creator_id)
  end
end
