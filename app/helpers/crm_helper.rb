module CrmHelper
  def t_att(model, attribute)
    t("activerecord.attributes.#{model}.#{attribute}")
  end

  def label_block(label, attribute)
    content_tag(:tr) do
      content_tag(:th, label) +
          content_tag(:td, attribute, :style => 'text-align: left;')
    end

  end
end