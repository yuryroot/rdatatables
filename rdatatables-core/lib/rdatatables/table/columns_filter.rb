module RDataTables
  class Table
    class ColumnsFilter

      def initialize(table)
        @table = table
      end

      def filter
        filtered_columns = apply_filter(@table.class.columns, :if_func)
        apply_filter(filtered_columns, :unless_func)
      end

      def apply_filter(columns, function_name)
        columns.map do |column|
          function = column.options.fetch(function_name)
          next column unless function

          function_result = @table.instance_exec(&function)
          function_result = !function_result if function_name == :unless_func

          column if function_result
        end.compact
      end
    end
  end
end
