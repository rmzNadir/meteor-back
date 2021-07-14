class ProductsServices::Relations
  def initialize(product, params)
    @product = product
    @params = params
  end

  def call(create: true)
    if create
      create_relations
    else
      update_relations
    end
  end

  def create_relations
    @params[:languages].split(',').each do |id|
      @product.product_has_languages.create(language_id: id)
    end

    @params[:platforms].split(',').each do |id|
      @product.product_has_platforms.create(platform_id: id)
    end
  end

  def update_relations
    platforms = @params[:platforms].split(',')
    languages = @params[:languages].split(',')

    old_platforms = ProductHasPlatform.where(product_id: @product.id).pluck(:platform_id)
    platforms_to_delete = old_platforms - platforms

    platforms_to_delete.each do |platform_id|
      ProductHasPlatform.find_by(platform_id: platform_id, product_id: @product.id).destroy
    end

    platforms.each do |platform_id|
      ProductHasPlatform.find_or_create_by(platform_id: platform_id, product_id: @product.id)
    end

    old_langs = ProductHasLanguage.where(product_id: @product.id).pluck(:language_id)
    langs_to_delete = old_langs - languages

    langs_to_delete.each do |language_id|
      ProductHasLanguage.find_by(language_id: language_id, product_id: @product.id).destroy
    end

    languages.each do |language_id|
      ProductHasLanguage.find_or_create_by(language_id: language_id, product_id: @product.id)
    end
  end
end
