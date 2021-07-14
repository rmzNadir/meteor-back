class ProductsServices::Dashboard
  def initialize; end

  def call
    dashboard_info
  end

  def dashboard_info
    {
      total_records: Product.count,
      low_stock: Product.all.select(:id, :name, :stock).order(stock: :asc).limit(3),
      possible_sales: Product.all.select(:id, :name, :stock).order(stock: :desc).limit(3),
      latest_addition: ProductSerializer.new(Product.last)
    }
  end
end
