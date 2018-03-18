module RDataTables
  class Table
    class ColumnsManager

      def initialize(table)
        @table = table
      end

      def append(*new_column_args)
        append_to_position(-1, *new_column_args)
      end

      def before(target_column_name, *new_column_args)
        target_column_position = position_of(target_column_name)
        append_to_position(target_column_position, *new_column_args)
      end

      def after(target_column_name, *new_column_args)
        target_column_position = position_of(target_column_name)
        append_to_position(target_column_position + 1, *new_column_args)
      end

      def instead_of(target_column_name, *new_column_args)
        target_column_position = position_of(target_column_name)
        @table.columns.delete_at(target_column_position)
        append_to_position(target_column_position, *new_column_args)
      end

      private

      def append_to_position(index, *new_column_args)
        column = Column.new(*new_column_args)

        if @table.columns.include?(column)
          raise "Column '#{column.name}' already exists"
        else
          @table.columns.insert(index, column)
        end

        column
      end

      def position_of(column_name)
        index = @table.columns.index { |column| column.name == column_name.to_sym }
        return index if index

        raise "Column '#{column_name}' doesn't exist"
      end
    end
  end
end
