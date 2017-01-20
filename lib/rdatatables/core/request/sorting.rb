module RDataTables
  module Core
    class Request
      class Sorting
        attr_reader :columns
        attr_reader :count

        def initialize(params:, table:)
          @columns = []
          @count = params['iSortingCols'].to_i

          @count.times.each do |index|
            column_index  = Integer(params.fetch("iSortCol_#{index}"))
            direction     = params.fetch("sSortDir_#{index}")
            column_name   = table.class.columns.keys[column_index]

            @columns << ColumnOrder.new(column: column_name, direction: direction)
          end
        end
      end
    end
  end
end