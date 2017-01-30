module RDataTables
  module Core
    class Request
      class Searching
        attr_reader :global_filter
        attr_reader :filters

        # TODO: Process params of global search.
        #   "sSearch" - Global search field.
        #   "bRegex" - True if the global filter should be treated as a regular
        #              expression for advanced filtering, false if not.

        def initialize(params:, table:)
          @filters = []

          table.class.columns.each_with_index do |column, index|
            search_string = params["sSearch_#{index}"]
            next if search_string.length == 0

            regexp     = params.fetch("bRegex_#{index}") == 'true'
            searchable = params.fetch("bSearchable_#{index}") == 'true'

            @filter << Filter.new(column: column, search: search_string,
                                  regexp: regexp, searchable: searchable)
          end
        end
      end
    end
  end
end

require_relative 'searching/filter'