class CompaniesController < ApplicationController
  unloadable

  before_filter :find_project, :only => :index
  before_filter :global_access

  def index
    @companies = Company.order(:name)
    if params[:search]
       search = params[:search]
       search.delete_if { |k, v| v.empty? }
       @companies = @companies.where(search)
    end
    if params[:tag].present?
      @companies = @companies.tagged_with(params[:tag])
    end
    if params[:project_id]
      @companies = @companies.from_project(@project.id)
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



  def import
    Company.import(params[:file])
    redirect_to companies_url, notice: "Companies imported."
  end

  private
  def company_params
    params.required(:company).permit(:name, :extra_information, :zip_code, :state, :province, :street, :url, :mail, :branch, :organisation)
  end

  def find_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def global_access
      authorize unless User.current.admin?
  end
end
