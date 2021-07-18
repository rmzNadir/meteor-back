class SaleQuery
  attr_reader :relation

  def initialize(base_relation = Sale.all)
    @relation = base_relation.extending(Scopes)
  end

  module Scopes
    def search_with_params(params, user = nil)
      result = self
      result = result.where(user_id: user.id) unless user.nil?
      result = result.by_search_term(params[:q]) if params[:q].present?
      result
    end

    def by_search_term(search)
      search_key = "%#{search.parameterize(separator: '')}%"

      where(
        "UNACCENT(REPLACE(address, ' ', '')) ILIKE :search
              OR total::text ILIKE :search
              OR subtotal::text ILIKE :search
              OR shipping_total::text ILIKE :search
              OR payment_method = CASE
              WHEN 'tarjetadecredito' ILIKE :search THEN
                0
              WHEN 'tarjetadedebito' ILIKE :search THEN
                1
              END
              OR payment_info ILIKE :search
              OR id::text ILIKE :search",
        search: search_key,
      )
    end
  end
end
