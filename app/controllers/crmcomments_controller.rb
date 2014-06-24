class CrmcommentsController < ApplicationController
  unloadable
  before_filter :find_commentable

  def index
    @comments = @commentable.crmcomments

    respond_to do |format|
      format.html
      format.csv {send_data CrmComment.to_csv(Crmcomment.all)}
      format.json
    end
  end

  def show
    @comment = Crmcomment.find(params[:id])
  end

  def new
    @comment = Crmcomment.new
  end

  def create
    @comment = @commentable.crmcomments.build(params[:crmcomment])
    @comment.save
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def edit
    @comment = Crmcomment.find(params[:id])
  end

  def update
    @comment = Crmcomment.find(params[:id])
    if @comment.update_attributes(params[:crmcomment])
      flash[:success] = "Comment updated."
      redirect_to @commentable
    end
  end

  def destroy
    Crmcomment.find(params[:id]).destroy
    flash[:success] = "Comment deleted."
    redirect_to request.referer
  end

  def import
    begin
      Crmcomment.import(params[:file])
      redirect_to companies_path, notice: 'Comments imported.'
    rescue
      flash[:failure] = 'Error: ' + $!.message
      redirect_to companies_path
    end
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable =  $1.classify.constantize.find(value)
        return @commentable
      end
    end
    nil
  end


end
