class Stonknote < ApplicationRecord
  has_many :tickers, class_name: 'StonknoteTicker'
  has_many :hashtags, class_name: 'StonknoteHashtag'

  enum call_result: { no_call: 0, correct: 1, incorrect: 2, partial: 3 }

  scope :showing, -> { where(hide: false) }
  scope :with_cursor, ->(cursor) { where('id < ?', cursor) if cursor.present? }
end
