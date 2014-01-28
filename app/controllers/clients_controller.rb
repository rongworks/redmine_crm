class ClientsController < ApplicationController
  unloadable


  def index
    @companies = Client.all
  end

  def show
    @company = Client.find(params[:id])
  end

  def new
    @company = Client.new
  end

  def create
  end

  def edit
    @company = Client.find(params[:id])
  end

  def update
    @company = Client.find(params[:id])
  end

  def destroy
    @company = Client.find(params[:id])
  end
end
