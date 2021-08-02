class XlsxExport::Products < XlsxExport::Main
  FORMAT_ROW = [
    "integer",
    "string",
    "currency",
    "string",
    "integer",
    "string",
    "string",
    "string",
    "string",
    "currency",
    "datetime",
    "string",
    "datetime"
  ].freeze

  HEADERS = [
    "ID",
    "NOMBRE",
    "PRECIO",
    "DESCRIPCIÓN",
    "DISPONIBLES",
    "PLATAFORMAS",
    "LENGUAJES",
    "DISTRIBUIDOR",
    "ENVÍO GRATIS",
    "COSTO DE ENVÍO",
    "VENDIDO POR ÚLTIMA VEZ",
    "ACTIVO",
    "FECHA DE REGISTRO"
  ].freeze

  def call
    package = Axlsx::Package.new
    wb = package.workbook
    wb.styles do |style|
      style_row = xlsx_styles(style, FORMAT_ROW)
      wb.add_worksheet(name: 'Reporte') do |sheet|
        h_style = style.add_style(header_style)
        sheet.add_row HEADERS, style: h_style, row_offset: 1
        @records.each do |record|
          row = map_row(record)
          sheet.add_row row, row_offset: 2, style: style_row
        end
      end
    end
    package
  end

  private

  def map_row(record)
    [
      record.id,
      record.name,
      record.price,
      record.description,
      record.stock,
      record.product_has_platforms.empty? ?  '-' : record.product_has_platforms.map { |r| r.platform.name }.join(', '),
      record.product_has_languages.empty? ?  '-' : record.product_has_languages.map { |r| r.language.name }.join(', '),
      record.provider,
      record.has_free_shipping ? "✔️" : "❌",
      record.shipping_cost,
      record.last_bought_at || '-',
      record.disabled ? "❌" : "✔️",
      record.created_at
    ]
  end

  def parse_payment_method(payment_method)
    case payment_method
    when "credit_card"
      "Tarjeta de crédito"
    when "debit_card"
      "Tarjeta de débito"
    else
      '-'
    end
  end
end
