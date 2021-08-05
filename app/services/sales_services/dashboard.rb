class SalesServices::Dashboard
  include Pundit
  require "date"

  def initialize; end

  def call
    dashboard_info
  end

  def dashboard_info
    {
      week_sales:
          [
            find_days_ago(6),
            find_days_ago(5),
            find_days_ago(4),
            find_days_ago(3),
            find_days_ago(2),
            find_days_ago(1),
            find_days_ago(0)
          ],
      most_sold: most_sold,
      top_buyer: top_buyer,
      top_5_products: ActiveModel::Serializer::CollectionSerializer.new(Product.order(times_bought: :desc).limit(5), each_serializer: ProductSerializer)
    }
  end

  private

  def find_days_ago(day)
    sales = Sale.where("created_at BETWEEN ? AND ?", day.days.ago.beginning_of_day, day.days.ago.end_of_day)
    {
      name: 'Ventas',
      date: DateTime.now.days_ago(day).iso8601(3),
      sales: sales.count
    }
  end

  # Add product count to total sales calculation
  def top_buyer
    all_sales = Sale.count
    user = User.left_joins(:sales).group('users.id').order('COUNT(sales.id) DESC').first

    {
      user: UserSerializer.new(user),
      all_sales: all_sales,
      user_sales: user.sales.count,
      percentage: (user.sales.count * 100) / all_sales,
    }
  end

  def most_sold
    all_sales = Product.all.sum(:times_bought)
    most_sold = Product.order(times_bought: :desc).first

    {
      all_sales: all_sales,
      percentage: (most_sold.times_bought * 100) / all_sales,
      product: ProductSerializer.new(most_sold)
    }
  end

  def search_params
    @params.permit(
      :q,
    )
  end

  protected

  def pundit_user
    @current_user
  end
end
