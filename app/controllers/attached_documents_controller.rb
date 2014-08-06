
class AttachedDocumentsController < ApplicationController
  require 'carrierwave'
  require 'carrierwave/orm/activerecord'
  include SharedModule
  unloadable
  before_filter :find_container, :except => [:index]
  before_filter :global_access

  def index
    @documents = AttachedDocument.all
  end

  def new
    @document = @container.attached_documents.build
  end

  def create
    @document = AttachedDocument.new(params[:attached_document])
    if @document.save
      flash[:success] = "document attached"
      redirect_to @document.container
    else
      flash[:failure] = "Could not attach document"
      redirect_to @document.container
    end
  end

  def edit
    @document = AttachedDocument.find(params[:id])
  end

  def update
    @document = AttachedDocument.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:attached_document])
        format.html do
         redirect_to @document.container, notice: "document attached"
        end
        format.js
      else
        format.html do
          flash[:failure] = "Could not attach document"
          redirect_to @document.container
        end
        format.js
      end
    end
  end

  def destroy
    AttachedDocument.find(params[:id]).destroy
    redirect_to :back , notice: 'Document deleted.'
  end

  def download_file
    @document = AttachedDocument.find(params[:id])
    send_file(@document.file.path,
              :disposition => 'attachment',
              :url_based_filename => false)
  end

  def authorize_lock_holder
    allowed = User.current == @document.lock_holder || User.current.admin?
    if !allowed
      flash[:failure] = "document is locked by #{@document.lock_holder}"
      redirect_to @document.container
    end
  end

  def switch_locked
    @document = AttachedDocument.find(params[:id])
    has_lock = @document.locked?
    answer = has_lock ? 'unlocked':'locked'
    lock_holder = has_lock ? nil : User.current

    authorize_lock_holder if has_lock

    respond_to do |format|
      if @document.update_attributes(:locked =>!has_lock, :lock_holder => lock_holder)
        format.html do
          redirect_to @document.container, notice: "document #{answer} by #{User.current}"
        end
        format.js
      else
        format.html do
          flash[:failure] = "document could not be #{answer}"
          redirect_to @document.container
        end
        format.js
      end
    end
  end

  private

  def find_container
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @container =  $1.classify.constantize.find(value)
        return @container
      end
    end
    nil
  end
end
