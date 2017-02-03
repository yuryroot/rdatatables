module RDataTables
  module Core
    class Request
      class Searching
        attr_reader :global_filter
        attr_reader :filters

        def initialize(params:, table:)
          @global_filter = nil
          @filters = []

          table.class.columns.each_with_index do |column, index|
            search_string = params["sSearch_#{index}"]
            next if search_string.nil? || search_string.length == 0

            regexp     = params.fetch("bRegex_#{index}") == 'true'
            searchable = params.fetch("bSearchable_#{index}") == 'true'

            @filters << ColumnFilter.new(column: column, search: search_string,
                                         regexp: regexp, searchable: searchable)
          end

          global_search_string = params['sSearch']
          if global_search_string && global_search_string.length > 0
            regexp = params.fetch('bRegex') == 'true'
            @global_filter = GlobalFilter.new(search: global_search_string, regexp: regexp)
          end
        end
      end
    end
  end
end

%w(global column).each do |type|
  require_relative "searching/#{type}_filter"
end
