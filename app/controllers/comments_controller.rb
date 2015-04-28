class CommentsController < ApplicationController
  before_action :set_event
  before_action :set_comment, except: [:index, :create]

  def index
    @comments = @event.comments
  end

  def show
  end

  def create
    @comment = @event.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render :show, status: :created, location: [@event, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render :show, status: :ok, location: [@event, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
