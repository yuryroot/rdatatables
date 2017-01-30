module RDataTables
  module Core
    class Request
      class Searching
        class Filter
          attr_reader :column
          attr_reader :search
          attr_reader :regexp
          attr_reader :searchable

          # TODO: Define separate class for global filter.
          #       For now "column" can be nil for global search field.
          def initialize(column: nil, search:, regexp:, searchable:)
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