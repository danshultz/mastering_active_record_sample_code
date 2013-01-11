class Style < ActiveRecord::Base
  has_many :beers
  has_many :breweries, :through => :beers
  attr_accessible :description, :name

  class << self

    def by_name(name)
      where(name: name)
    end

    def not_names(*names)
      names = names.flatten
      where(Style.arel_table[:name].not_in(names))
    end

  end
end
