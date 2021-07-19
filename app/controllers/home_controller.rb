class HomeController < ApplicationController
  def index
    @result = Stonknote.showing.order(id: :desc).first(20).map { |sn| StonknotePresenter.new(sn) }
  end
end
