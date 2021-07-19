class StonknotePresenter < SimpleDelegator

  def stonknote_show_timestamp
    "#{(stonknote_time || created_at).strftime('%Y-%m-%d %l:%M%P')} - #{id}"
  end

end