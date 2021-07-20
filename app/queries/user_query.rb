class UserQuery
  attr_reader :relation

  def initialize(base_relation = User.all)
    @relation = base_relation.extending(Scopes)
  end

  module Scopes
    def search_with_params(params)
      result = self
      result = result.by_search_term(params[:q]) if params[:q].present?
      result
    end

    def by_search_term(search)
      search_key = "%#{search.strip}%"

      where(
        "UNACCENT(REPLACE(email, ' ', '')) ILIKE :search
          OR UNACCENT(REPLACE(name,' ','')) ILIKE :search
          OR UNACCENT(REPLACE(last_name, ' ', '')) ILIKE :search
          OR role = CASE
            WHEN 'usuario' ILIKE :search THEN
              0
            WHEN 'administrador' ILIKE :search THEN
              1
            WHEN 'gerente' ILIKE :search THEN
              2
          END",
        search: search_key
      )
    end
  end
end
