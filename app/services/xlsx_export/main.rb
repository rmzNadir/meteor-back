class XlsxExport::Main
  def initialize(records)
    @records = records
  end

  protected

  def header_style
    { bg_color: "C598D8", fg_color: "f3eaf7", sz: 14, b: true, alignment: { horizontal: :center } }
  end

  def xlsx_styles(style, format_row)
    styles = {}
    formats = {
      date: { format: "dd/mm/yyyy" },
      datetime: { format: "dd/mm/yyyy hh:mm" },
      currency: { format: "[$$-es-MX]#,##0.00" },
      integer: { format: "0" },
      string: { format: "@" },
      number: { format: "#,##0" },
      hour: { format: "dd hh:mm:ss" },
      percent: { format: "0%" }
    }
    formats.each do |key, value|
      styles[key] = style.add_style(sz: 14, bg_color: "ede0f3", alignment: { horizontal: :center }, format_code: value[:format])
    end

    style = []

    format_row.each do |row|
      style_select = styles[row.downcase.to_sym]
      style.push style_select
    end

    style
  end
end
