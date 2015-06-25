
class CompaniesController < ApplicationController
  include SharedModule
  include CrmHelper
  unloadable
  layout 'companies_layout'

  require 'zip/zip'
  require 'zip/zipfilesystem'

  def index

    respond_to do |format|
      format.html
      format.csv {
        #send_data Company.to_csv(@companies).encode(Setting.plugin_redmine_crm['csv_encoding'])
        get_csv_with_clients(@companies_no_paging)
      }
      format.json{
        #@companies = Company.from_project(@project.id)
        @companies = @project.companies
        if params[:search]
          search = params[:search]
          search.delete_if { |k, v| v.empty? }
          @companies = @companies.where(search)
        end
        if params[:tag].present?
          @companies = @companies.tagged_with(params[:tag], :on => :tags)
        end
        if params[:branch].present?
          @companies = @companies.tagged_with(params[:branch], :on => :branches)
        end


        @companies_no_paging = @companies
        @limit = params['per_page'].blank? ? (25) : (params['per_page'].to_i)
        @companies = @companies.limit(@limit).offset(@offset).paginate(:page => params['page'], :per_page => @limit).order(:name)
        render json: @companies_no_paging, :root => false
      }
    end
  end

  def show
    @company = Company.find(params[:id])
    @comments = @company.crmcomments
    @comment = Crmcomment.new
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    @company.save
    redirect_to @company
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    params[:company][:project_ids] ||= []
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      if(params[:crmcomment])
        @company.crmcomments.build(params[:crmcomment])
      end
      @company.save!
      redirect_to @company
    else
      flash[:failure] = "Company could not be saved: "+@company.errors.to_s
      render :edit
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    flash[:success] = "Company deleted."
    redirect_to companies_url
  end

  def destroy_all
    Company.destroy_all
    flash[:success] = "Companies deleted."
    redirect_to companies_url
  end

  def info
    @companies = Company.all
    if request.xhr?
      @company = Company.find(params[:id])

      render :partial => "info", :object => @company
    else
      @company = @companies.first unless @companies.empty?
    end
  end

  def import
    begin
      Company.import(params[:file])
      redirect_to companies_url, notice: 'Companies imported.'
    rescue
      flash[:failure] = 'Error: ' + $!.message
      redirect_to companies_url
    end
  end

  def change_root_project
    Company.all.each do |company|
      if params[:delete_old_project]
        old_project = Project.find(params[:old_project])
        if company.projects.include? old_project
          company.projects.delete old_project
        end
      end
      new_project = Project.find(params[:new_project])
      company.projects << new_project unless company.projects.include? new_project
      company.save!
    end
    redirect_to :back, notice: 'updated'
  end

  def reset_primary_contacts
    Company.reset_primary_contacts
    redirect_to :back, notice: 'updated'
  end

  private
  def get_csv_with_clients(companies)
    clientEntries = []
    companies.each do |comp|
      clientEntries.concat(comp.clients) unless comp.clients.empty?
    end
    encoding = Setting.plugin_redmine_crm['csv_encoding']
    t = Tempfile.new("some-weird-temp-file-basename")

    Zip::ZipOutputStream.open(t.path) do |zos|
      zos.put_next_entry('clients.csv')
      clients = Tempfile.open("clients.csv", encoding: encoding) do |f|
        f.print(Client.to_csv(clientEntries).encode(encoding))
        f.flush
      end
      zos.print IO.read(clients)
      zos.put_next_entry('companies.csv')
      companies = Tempfile.open("companies.csv", encoding: encoding) do |f|
        f.print(Company.to_csv(companies).encode(encoding))
        f.flush
      end
      zos.print IO.read(companies)
    end
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "company_export.zip"
    t.close

  end
  def company_params
    params.required(:company).permit(:name, :extra_information, :zip_code, :state, :province, :street, :url, :mail, :branch, :organisation)
  end
end
