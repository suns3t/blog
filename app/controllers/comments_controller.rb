class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:show, :edit, :update, :destroy]


  # POST /comments
  # POST /comments.json
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to root_path , notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to root_path, notice: 'Comment should not be empty.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    # Check if comment belongs to you
    if (@comment.user_id == current_user.id)
        @comment.destroy
    else 
        flash[:notice] = "You only can delete your owned comments."
        redirect_to root_url
    end

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      begin
        @comment = Comment.find(params[:id])  
      rescue Exception
        flash[:notice] = "Comment with id=" + params[:id] + " is not found."
        redirect_to root_url
      end
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :article_id, :user_id)
    end
end
