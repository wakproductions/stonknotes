class HomeController < ApplicationController
  def index
    @stonknotes = Stonknote.order(id: :desc).limit(20)
  end
end
