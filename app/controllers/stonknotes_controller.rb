class StonknotesController < ApplicationController

  def index
    @result =
      Stonknote
      .showing
      .then { |q| params[:cursor].present? ? q.where('id < ?', params[:cursor]) : q }
      .order(id: :desc)
      .first(20)
      .map { |sn| StonknotePresenter.new(sn) }

    respond_to do |format|
      format.turbo_stream { render(layout: false) } # For infinite scroll - loads more
      format.html
    end
  end

  def create
    # TODO remove this code with actual code that validates the stonknote. This is just dummy code for testing the modal
    new_stonknote = Stonknote.new(stonknote)
    new_stonknote.assign_attributes(
      stonknote_time: Time.current,
      symbol: "XYZ",
      stonknote_date: Date.current,
    )
    @result = StonknotePresenter.new(new_stonknote)

    respond_to do |format|
      if new_stonknote.valid?
        format.turbo_stream { render(layout: false) }
        format.html { redirect_to :stonknotes_path }
      else
        format.turbo_stream { render(layout: false) }
        format.html
      end
    end
  end

  def new
    @result = Stonknote.new
  end

  private

  def stonknote
    params.require(:stonknote).permit(:message)
  end

end
