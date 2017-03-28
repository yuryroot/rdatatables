module RDataTables
  module Core
    module Table
      class Column
        attr_reader :name
        attr_reader :options

        def initialize(column, options = {})
          @name = column.to_s
          @options = DEFAULT_OPTIONS.merge(process_options(options))
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

        def process_options(options)
          options.map { |option, value| [option.to_sym, value] }.to_h
        end
      end
    end
  end
end