class StonknotesReflex < ApplicationReflex
  def load
    stonknotes = Stonknote.order(id: :desc).limit(20).with_cursor(element.dataset.cursor)
    self.payload = stonknotes.any? ? stonknotes.last.id : 1
    html = render partial: "stonknotes/stonknote", collection: stonknotes
    cable_ready.append(selector: "#stonknotes", html: html)
    morph :nothing
  end
end