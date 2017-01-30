module RDataTables
  module Core
    module Table
      class Column
        attr_reader :name
        attr_reader :options

        def initialize(column, options = {})
          @name = column.to_s
          @options = options
        end

        def == (other)
          @name == other.name
        end
      end
    end
  end
end