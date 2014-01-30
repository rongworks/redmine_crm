class CompaniesController < ApplicationController
  unloadable


  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
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
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:failure] = "Company could not be saved"
      redirect_to @company
    else
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

end
