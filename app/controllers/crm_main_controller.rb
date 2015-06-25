class CrmMainController < ApplicationController
  include SharedModule
  include CrmHelper
  unloadable

  def index
    render 'crm_main/crm_main'
  end
end