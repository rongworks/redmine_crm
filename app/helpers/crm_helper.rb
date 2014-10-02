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

  def attached_documents_and_new(container)
    (render 'attached_documents/attached_documents_list', :documents => container.attached_documents).to_s.html_safe +
    '<hr>'.html_safe +
    (render 'attached_documents/form', :container => container).to_s.html_safe
  end

end