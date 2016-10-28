module RDataTables
  module Core
    class Collection
      
      def initialize(table:, collection:, request:)
        @table = table
        @collection = collection
        @request = request
      end

      def process
        filter
        sort
        paginate
      end

      def filter
        call_overridden_or_block(__method__, @collection, @request)
      end

      def sort
        call_overridden_or_block(__method__, @collection, @request) do
          return if @request.sorting_columns.empty?

          sorting_columns.each do |column, direction|
            sort_by(column, direction)
          end
        end
      end

      def sort_by(column, direction)
        call_overridden_or_block(__method__, column, direction) do
          sort_method = "sort_by_#{column}"
          
          if overridden?(sort_method)
            @table.send(sort_method, column, direction)
          end
        end
      end

      def paginate
        call_overridden_or_block(__method__, @collection, @request)
      end

      protected

      def overridden?(method)
        @table.respond_to?(method)
      end

      def call_overridden_or_block(method, *params, &block)
        if overridden?(method)
          @table.send(method, *params)
        else
          block.call if block_given?
        end
      end
    end
  end
end  