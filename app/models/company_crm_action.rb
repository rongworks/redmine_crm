class CompanyCrmAction < ActiveRecord::Base
  unloadable

  belongs_to :company
  belongs_to :crm_action
end
