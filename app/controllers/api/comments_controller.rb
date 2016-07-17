class API::CommentsController < API::APIController
  before_action :set_event, except: [:update, :destroy]
  before_action :set_comment, except: [:index, :create]

  def index
    @comments = @event.comments
  end

  def create
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: 422
    end
  end

  def update
    authorize @comment

    if @comment.update(comment_params)
      head :ok
    else
      render json: @comment.errors, status: 422
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :respondent_id)
  end
end
