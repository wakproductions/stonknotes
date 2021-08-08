module StonknotesHelper
  def stonknote_form_title(stonknote)
    stonknote.id.present? ? 'Edit Stonknote' : 'New Stonknote'
  end

  def stonknote_show_class(stonknote)
    if stonknote.call_result.present?
      "stonknote-show stonknote-show--call-#{stonknote.call_result}"
    else
      'stonknote-show'
    end
  end
end
