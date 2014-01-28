class CompaniesController < ApplicationController
  unloadable


  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
  end

  def destroy
    @company = Company.find(params[:id])
  end
end
