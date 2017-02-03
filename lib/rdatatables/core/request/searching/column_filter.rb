module RDataTables
  module Core
    class Request
      class Searching
        class ColumnFilter
          attr_reader :column
          attr_reader :search
          attr_reader :regexp # TODO: regexp attribute isn't supported yet
          attr_reader :searchable

          def initialize(column:, search:, regexp:, searchable:)
            @column = column
            @search = search
            @regexp = regexp
            @searchable = searchable
          end
        end
      end
    end
  end
end