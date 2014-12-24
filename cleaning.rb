require 'pp'
require 'csv'


filename = "children_data2005_08_130819.csv"

class CSV::Table
  def group_by(&blk)
    Hash[ super.map { |k, v| [k, CSV::Table.new(v)] } ]
  end
end

def cal_blank table
  num = table.size
  blanks = []
  table.headers.each do |key|
    blanks << (num - table[key].count(nil)) / num.to_f
  end
  blanks
end


table = CSV.table(filename, encoding: "Shift_JIS:UTF-8", header_converters: nil)

outfile = open("./outputs/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{File.basename(filename, ".*")}.csv", "w")
outfile.print "\t", table.headers.join("\t").gsub("\r\n", "<br>"), "\n"


# カテゴリ型
table.group_by{|row| row["性別"]}.each do |sex, table_elem|
  p sex
  outfile.print sex, "\t"
  outfile.print (cal_blank table_elem).join("\t")
  outfile.print  "\n"
end
