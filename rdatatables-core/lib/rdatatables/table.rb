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
        column = Column.new(name, options)

        if columns.include?(column)
          raise "Column '#{column.name}' already exists"
        else
          columns << column
        end
      end

      def inherited(child)
        columns.each do |parent_column|
          child.column(parent_column.name, parent_column.options)
        end
      end
    end
  end
end