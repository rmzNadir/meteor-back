class XlsxExport::Orders < XlsxExport::Main
  FORMAT_ROW = [
    "string",
    "string",
    "string",
    "currency",
    "currency",
    "currency",
    "string",
    "string",
    "string",
    "datetime"
  ].freeze

  HEADERS = [
    "USUARIO",
    "NO. ORDEN",
    "PRODUCTOS",
    "SUBTOTAL",
    "ENVÍO",
    "TOTAL",
    "DIRECCIÓN",
    "MÉTODO DE PAGO",
    "TARJETA",
    "FECHA"
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
          service = map_service(record)
          sheet.add_row service, row_offset: 2, style: style_row
        end
      end
    end
    package
  end

  private

  def map_service(record)
    [
      "#{record.user.name} #{record.user.last_name}",
      record.id,
      record.has_sales.reduce(0) { |acc, cur| acc + cur.quantity },
      record.subtotal,
      record.shipping_total,
      record.total,
      record.address,
      parse_payment_method(record.payment_method),
      record.payment_info.chars.last(4).join,
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
