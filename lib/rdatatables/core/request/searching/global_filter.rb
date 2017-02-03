module RDataTables
  module Core
    class Request
      class Searching
        class GlobalFilter
          attr_reader :search
          attr_reader :regexp # TODO: regexp attribute isn't supported yet

          def initialize(search:, regexp:)
            @search = search
            @regexp = regexp
          end
        end
      end
    end
  end
end