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
    new_stonknote = Stonknote.new(stonknote)
    new_stonknote.assign_attributes(
      stonknote_time: Time.current,
      symbol: "XYZ",
      stonknote_date: Date.current,
    )
    @result = [StonknotePresenter.new(new_stonknote)]

    respond_to do |format|
      format.turbo_stream do
        render(
          turbo_stream: turbo_stream.prepend(
            :stonknotes_content, partial: 'stonknotes', locals: { stonknotes: @result }
        ))
      end
      format.html { redirect_to :stonknotes_path }
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
