class ProductQuery
  attr_reader :relation

  def initialize(base_relation = Product.all)
    @relation = base_relation.extending(Scopes)
  end

  module Scopes
    def search_with_params(params)
      result = self
      result = result.by_search_term(params[:q]) if params[:q].present?
      result
    end

    def by_search_term(search)
      search_key = "%#{search.parameterize(separator: '')}%"

      where(
        "UNACCENT(REPLACE(description, ' ', '')) ILIKE :search
            OR UNACCENT(REPLACE(name,' ','')) ILIKE :search
            OR UNACCENT(REPLACE(provider, ' ', '')) ILIKE :search
            OR id in (:search_ids)",
        search: search_key,
        # TODO: Check if this is right:
        # "Left joins are faster in this case because where are not
        # searching the obvious in the platform and languages tables"
        search_ids: Product.left_outer_joins(:languages, :platforms)
        .where(
          "UNACCENT(REPLACE(platforms.name, ' ', '')) ILIKE :search
          OR UNACCENT(REPLACE(languages.name, ' ', '')) ILIKE :search",
          search: search_key
        ).select(:id)
      )
    end
  end
end
