# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments
  def index
    @comments = Comment.all
    audit! :list_comment
  end

  # GET /comments/1
  def show
    audit! :show_comment, @comment
  end

  # GET /comments/new
  def new
    audit! :new_comment
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    audit! :edit_comment, @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      audit! :create_comment, @comment, payload: comment_params
      redirect_to @comment, notice: "Comment was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      audit! :update_comment, @comment, payload: comment_params
      redirect_to @comment, notice: "Comment was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    audit! :delete_comment, @comment, payload: @comment.attributes
    redirect_to comments_url, notice: "Comment was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:topic_id, :user_id, :body)
  end
end
