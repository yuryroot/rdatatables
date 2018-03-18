module RDataTables
  class Table
    class Column
      attr_reader :name
      attr_reader :options

      DEFAULT_OPTIONS = { sortable: true, searchable: true }

      def initialize(column, options = {})
        @name = column.to_sym
        @options = DEFAULT_OPTIONS.merge(Helpers.symbolize_keys(options))
      end

      def sortable?
        @options[:sortable]
      end

      def searchable?
        @options[:searchable]
      end

      def == (other)
        @name == other.name
      end
    end
  end
end
