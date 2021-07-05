require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Description", with: @product.description
    check "Has free shipping" if @product.has_free_shipping
    fill_in "Last bought at", with: @product.last_bought_at
    fill_in "Name", with: @product.name
    fill_in "Price", with: @product.price
    fill_in "Provider", with: @product.provider
    fill_in "Shipping cost", with: @product.shipping_cost
    fill_in "Stock", with: @product.stock
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Description", with: @product.description
    check "Has free shipping" if @product.has_free_shipping
    fill_in "Last bought at", with: @product.last_bought_at
    fill_in "Name", with: @product.name
    fill_in "Price", with: @product.price
    fill_in "Provider", with: @product.provider
    fill_in "Shipping cost", with: @product.shipping_cost
    fill_in "Stock", with: @product.stock
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
