module ApplicationHelper

  def form_control_class(form_builder, field, base_classes = '')
    classes = base_classes.split
    if form_builder.object.errors[field].present?
      classes << 'is-invalid'
    end

    classes.uniq.join(' ')
  end

  def form_control_validation_message(form_builder, field)
    model = form_builder.object
    if model.errors[field].present?
      raw(
        tag.div(model.errors.full_messages_for(field).join(','), class: 'invalid-feedback--bsfixed')
      )
    end
  end

end
