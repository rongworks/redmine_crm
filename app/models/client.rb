class Client < ActiveRecord::Base
  unloadable

  belongs_to :company
end
