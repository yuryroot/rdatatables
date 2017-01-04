module RDataTables
  module Core
    class Processor
      
      def initialize(table:, collection:, request:)
        @table = table
        @collection = collection
        @collection_adapter = CollectionAdapter.adapter_for(collection)
        @request = request
      end

      def process
        filter
        sort
        paginate
      end

      def data_rows
        @collection.map { |object| data_row(object) }
      end

      def data_row(object)
        @table.class.columns.keys.map { |column| data_cell(object, column) }
      end

      def data_cell(object, column)
        call_overridden_or_block(column, object) do
          @collection_adapter.data_cell(object, column)
        end
      end

      def filter
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request) do
            @collection_adapter.filter
          end
        end
      end

      def sort
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request) do
            next @collection if @request.sorting_columns.empty?

            sorting_columns.each do |column, direction|
              sort_by(column, direction)
            end
          end
        end  
      end

      def sort_by(column, direction)
        @collection = begin
          call_overridden_or_block(__method__, @collection, column, direction) do
            call_overridden_or_block("sort_by_#{column}", @collection, column, direction) do
              @collection_adapter.sort_by(column, direction)
            end
          end
        end
      end

      def paginate
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request) do
            start_from, per_page = @request.pagination_info.values_at(:start_from, :per_page)
            @collection_adapter.paginate(@collection, start_from, per_page)
          end
        end
      end

      protected

      def overridden?(method)
        @table.respond_to?(method)
      end

      def call_overridden_or_block(method, *params, &block)
        if overridden?(method)
          @table.public_send(method, *params)
        else  
          block.call if block_given?
        end
      end
    end
  end
end  