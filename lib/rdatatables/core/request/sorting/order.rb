module RDataTables
  module Core
    class Request
      class Sorting
        class Order
          attr_reader :column
          attr_reader :direction
          attr_reader :sortable

          def initialize(column:, direction:, sortable:)
            @column    = column
            @direction = direction
            @sortable  = sortable
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
end