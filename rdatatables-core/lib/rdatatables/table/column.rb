module RDataTables
  class Table
    class Column
      attr_reader :name
      attr_reader :options

      DEFAULT_OPTIONS = { sortable: true, searchable: true }

      def initialize(column, options = {})
        @name = column.to_sym
        @options = DEFAULT_OPTIONS.merge(symbolize_keys(options))
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

      private

      def symbolize_keys(options)
        options.map { |option, value| [option.to_sym, value] }.to_h
      end
    end
  end
end
