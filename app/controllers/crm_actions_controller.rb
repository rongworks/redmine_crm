class CrmActionsController < ApplicationController
  include SharedModule
  unloadable
  layout 'companies_layout'
  helper :attachments
  include AttachmentsHelper


  def index
    @crm_actions = @project.crm_actions

    respond_to do |format|
      format.html
      format.csv {send_data CrmAction.to_csv(@crm_actions).encode(Setting.plugin_redmine_crm['csv_encoding']) }
    end
  end

  def new
    @crm_action = CrmAction.new
    if params[:company_ids].present?
      @crm_action.company_ids = params[:company_ids]
    end
  end

  def create
    @crm_action = CrmAction.new(params[:crm_action])
    if @crm_action.save
      redirect_to @crm_action, notice: 'CRM action created successfully'
    else
      flash[:error] = 'Could not create CRM action'
      render 'new'
    end
  end

  def show
    @crm_action = CrmAction.find(params[:id])
    @comments = @crm_action.crmcomments
    @comment = Crmcomment.new
  end

  def edit
    @crm_action = CrmAction.find(params[:id])
  end

  def update
    @crm_action = CrmAction.find(params[:id])
    @crm_action.save_attachments(params[:attachments] || (params[:crm_action] && params[:crm_action][:uploads]))
    if @crm_action.update_attributes(params[:crm_action])
      redirect_to @crm_action
    else
      flash[:failure] = "CrmAction could not be saved: "+@crm_action.errors.to_s
      render :edit
    end
  end

  def destroy
    @crm_action = CrmAction.find(params[:id])
    if @crm_action.destroy
      flash[:notice] = 'CrmAction successfully destroyed'
    end
    redirect_to crm_actions_path
  end

  def import
    begin
      CrmAction.import(params[:file])
      redirect_to crm_actions_path, notice: 'CrmActions imported.'
    rescue
      flash[:failure] = 'Error: ' + $!.message
      redirect_to crm_actions_path
    end
  end
end
