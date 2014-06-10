class CrmAction < ActiveRecord::Base
  unloadable
  has_many :company_crm_actions
  has_many :companies, :through => :company_crm_actions
end
