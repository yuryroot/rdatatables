module RDataTables
  module Core
    class Request
      class ColumnOrder
        attr_reader :column
        attr_reader :direction

        def initialize(column:, direction:)
          @column    = column
          @direction = direction
        end

        def asc?
          direction.to_s == 'asc'
        end

        def desc?
          !asc?
        end
      end
    end
  end
end