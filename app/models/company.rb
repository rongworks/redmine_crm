class Company < ActiveRecord::Base
  unloadable

  has_many :clients
end
