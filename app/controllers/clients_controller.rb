require 'carrierwave'
class ClientsController < ApplicationController
  unloadable
  include SharedModule
  layout 'companies_layout'

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
      format.csv {send_data Client.to_csv(@clients).encode(Setting.plugin_redmine_crm['csv_encoding']) }
    end
  end

  def show
    @client = Client.find(params[:id])
    @comment = Crmcomment.new
    @document = AttachedDocument.new

    respond_to do |format|
      format.html
      format.text {send_data @client.to_vcard.to_s, :filename => "#{@client.last_name}.vcf"	}
    end
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
    @document = @client.attached_documents.build
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      if(params[:crmcomment])
        @client.crmcomments.build(params[:crmcomment])
      end
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
