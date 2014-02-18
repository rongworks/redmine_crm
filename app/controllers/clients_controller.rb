class ClientsController < ApplicationController
  unloadable
  before_filter :global_access


  def index
    @clients = Client.all
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
    @client = Company.find(params[:id])
    if @client.update_attributes(params[:company])
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
    flash[:success] = "Client deleted."
    redirect_to companies_url
  end

  def import
    Client.import(params[:file])
    redirect_to clients_url, notice: "Clients imported."
  end

  private
  def client_params
    params.required(:client).permit(:first_name, :last_name, :title, :salutation, :salutation_letter, :department, :phone, :fax, :mail, :company_id)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def global_access
    authorize unless User.current.admin?
  end
end
