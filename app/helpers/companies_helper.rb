module CompaniesHelper
  def t_att(model, attribute)
    t("activerecord.attributes.#{model}.#{attribute}")
  end
end
