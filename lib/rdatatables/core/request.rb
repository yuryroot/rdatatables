module RDataTables
  module Core
    class Request
      
      def initialize(table:, params:)
        @table = table
        @params = params
      end

      def echo
        @params['sEcho'].to_i
      end

      def pagination_info
        @pagination_info ||= {}.tap do |info|
          info[:start_from] = @params['iDisplayStart'].to_i
          info[:per_page]   = @params['iDisplayLength'].to_i
          info[:page]       = info[:start_from] / info[:per_page] + 1
        end
      end

      # [[<column>, <direction>], [...], ...]
      def sorting_columns
        @sorting_columns ||= [].tap do |order|
          if @params['iSortingCols'].to_i >= 1
            @params['iSortingCols'].to_i.times.each do |index|
              column_index  = @params["iSortCol_#{index}"].to_i
              direction     = @params["sSortDir_#{index}"]
              column        = @table.class.columns.keys[column_index]
              order << [column, direction]
            end
          end
        end
      end
    end
  end
end