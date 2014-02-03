class CrmcommentsController < ApplicationController
  unloadable

  def index
    @comments = Crmcomment.all
  end

  def show
    @comment = Crmcomment.find(params[:id])
  end

  def new
    @comment = Crmcomment.new
  end

  def create
    @comment = Crmcomment.new(params[:crmcomment])
    @comment.save
    redirect_to @comment
  end

  def edit
    @comment = Crmcomment.find(params[:id])
  end

  def update
    @comment = Crmcomment.find(params[:id])
  end

  def destroy
    Crmcomment.find(params[:id]).destroy
    flash[:success] = "Comment deleted."
    redirect_to crmcomments_url
  end


end
