class ClientsController < ApplicationController
  unloadable
  include SharedModule
  layout 'companies_layout'

  helper :attachments
  include AttachmentsHelper

  def index
    @clients = @project.clients
    if params[:search]
      search = params[:search]
      search.delete_if { |k, v| v.empty? }
      @clients = @clients.where(search)
    end
    @limit = params['per_page'].blank? ? (25) : (params['per_page'].to_i)
    @clients = @clients.limit(@limit).offset(@offset).paginate(:page => params['page'], :per_page => @limit).order(:last_name)

    respond_to do |format|
      format.html
      format.csv {send_data Client.to_csv(@project.clients) }
    end
  end

  def show
    @client = Client.find(params[:id])
    @comment = Crmcomment.new
  end

  def new
    @client = Client.new(:company_id => params[:company_id])
  end

  def create
    @client = Client.new(params[:client])
    @client.save
    redirect_to @client
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    @client.save_attachments(params[:attachments] || (params[:client] && params[:client][:uploads]))
    render_attachment_warning_if_needed(@client)
    if @client.update_attributes(params[:client])
      if(params[:crmcomment])
        @client.crmcomments.build(params[:crmcomment])
      end
      @client.save!
      redirect_to @client
    else
      flash[:failure] = "Client could not be saved: "+@client.errors.to_s
      render :edit
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    redirect_to referrer.back , notice: 'Client deleted.'
  end

  def import
    begin
      Client.import(params[:file])
      redirect_to clients_url, notice: 'Clients imported.'
    rescue
      flash[:failure] = 'Error: ' + $!.message
      redirect_to clients_url
    end
  end

  private
  def client_params
    params.required(:client).permit(:first_name, :last_name, :title, :salutation, :salutation_letter, :department, :phone, :fax, :mail, :company_id, :attachments)
  end
end
