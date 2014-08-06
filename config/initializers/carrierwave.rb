require 'carrierwave'
require 'carrierwave/orm/activerecord'
require '/app/uploaders/document_uploader'
config.autoload_paths += "#{Rails.root}/app/uploaders"
