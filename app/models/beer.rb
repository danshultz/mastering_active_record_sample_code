class Beer < ActiveRecord::Base
  belongs_to :brewery
  belongs_to :style
  has_and_belongs_to_many :beer_drinkers
  attr_accessible :abv, :description, :name, :style, :brewery, :style_id, :brewery_id

  class << self
    alias_method :_, :arel_table

    def by_name(name)
      where(name: name)
    end

    def by_abv(abv)
      where(abv: abv)
    end

    def by_style_name(name)
      joins(:style).merge(Style.by_name(name))
    end

    def by_brewery_name(name)
      joins(:brewery).merge(Brewery.by_name(name))
    end

    def with_no_brewery
      where(brewery_id: nil)
    end

    def starts_or_ends_with(start, ending=nil)
      ending = ending || start
      where(_[:name].matches_any(["%#{ending}", "#{start}%"]))
    end

    def misclassified_ipas
      beer = Beer.arel_table
      style = Style.arel_table

      joins(:style).where(
        beer[:abv].lt(7.5).and(style[:name].eq("Imperial IPA")) \
        .or(beer[:abv].gt(7.4).and(style[:name].eq("IPA")))
      )
    end

    def misclassified_imperials_ipas_and_stouts
      beer = Beer.arel_table
      style = Style.arel_table

      joins(:style).where(
        style[:name].eq("Imperial IPA").or(style[:name].eq("Imperial Stout")) \
          .and(beer[:abv].lt(7.5))
      )
    end

    def misclassified_imperials_ipas_and_stouts_alt
      beer = Beer.arel_table
      style = Style.arel_table

      joins(:style).where(
        style[:name].eq_any(["Imperial IPA", "Imperial Stout"]) \
          .and(beer[:abv].lt(7.5))
      )
    end

    def create_style_join
      beer = Beer.arel_table
      style = Style.arel_table

      join_on = beer.create_on(beer[:style_id].eq(style[:id]))
      inner_join = beer.create_join(style, join_on)
      outer_join = beer.create_join(style, join_on, Arel::Nodes::OuterJoin)

      Beer.joins(inner_join)
      Beer.joins(outer_join)
    end

    def unions
      beer = Beer.arel_table
      union = Beer.where(name: "Oberon").union(Beer.where(name: "Two Hearted"))
      Beer.from(beer.create_table_alias(union, :beers)).all
    end

    def abv_lt(abv)
      where(Beer.arel_table[:abv].lt(abv))
    end

    def abv_gt(abv)
      where(Beer.arel_table[:abv].gt(abv))
    end

  end

end
