module RDataTables
  class Table

    class << self
      def columns
        if instance_variable_defined?(:@columns)
          instance_variable_get(:@columns)
        else
          instance_variable_set(:@columns, [])
        end
      end

      def column(name, options = {})
        options = Helpers.symbolize_keys(options)
        columns_manager = ColumnsManager.new(self)

        [:before, :after, :instead_of].each do |insert_position|
          target_column = options.delete(insert_position)

          if target_column
            return columns_manager.public_send(insert_position, target_column, name, options)
          end
        end

        columns_manager.append(name, options)
      end

      def inherited(child)
        columns.each do |parent_column|
          child.column(parent_column.name, parent_column.options)
        end
      end
    end
  end
end