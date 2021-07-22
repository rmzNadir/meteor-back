class XlsxExport::Users < XlsxExport::Main
  FORMAT_ROW = [
    "string",
    "string",
    "string",
    "string",
    "string",
    "datetime"
  ].freeze

  HEADERS = [
    "ID",
    "NOMBRE",
    "APELLIDOS",
    "EMAIL",
    "ROL",
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
      record.last_name,
      record.email,
      parse_role(record.role),
      record.created_at
    ]
  end

  def parse_role(role)
    case role
    when "admin"
      "Administrador"
    when "client_user"
      "Gerente"
    when "user"
      "Usuario"
    else
      '-'
    end
  end
end
