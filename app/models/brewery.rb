class Brewery < ActiveRecord::Base
  has_many :beers
  has_many :styles, :through => :beers
  attr_accessible :location, :name

  class << self

    def by_name(name)
      where(name: name)
    end

    def with_no_beers
      includes(:beers).merge(Beer.with_no_brewery)
    end

  end
end
