module RDataTables
  module Core
    class Request
      class Sorting
        attr_reader :columns

        def initialize(params:, table:)
          @columns = []

          params['iSortingCols'].to_i.times.each do |index|
            column_index  = Integer(params.fetch("iSortCol_#{index}"))
            column        = table.class.columns[column_index]
            direction     = params.fetch("sSortDir_#{index}")
            sortable      = params.fetch("bSortable_#{index}") == 'true'

            @columns << Order.new(column: column, direction: direction, sortable: sortable)
          end
        end
      end
    end
  end
end

require_relative 'sorting/order'