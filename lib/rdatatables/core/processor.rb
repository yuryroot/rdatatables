module RDataTables
  module Core
    class Processor

      def initialize(table:, collection:, request:, options: {})
        @table = table
        @collection = collection
        @collection_adapter = CollectionAdapters.adapter_for(collection)
        @request = request
        @total_count = options[:total_count] || @collection.count
      end

      def process
        filter
        sort
        paginate
      end

      def data_hash
        {
          sEcho:                @request.meta.echo,
          iTotalRecords:        @total_count,
          iTotalDisplayRecords: @collection.count,
          aaData:               data_rows
        }
      end

      def data_rows
        @collection.map { |object| data_row(object) }
      end

      def data_row(object)
        @table.class.columns.map { |column| data_cell(object, column) }
      end

      def data_cell(object, column)
        call_overridden_or_block(column.name, object) do
          @collection_adapter.data_cell(object, column)
        end
      end

      def filter
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request.searching) do
            if @request.searching.global_filter
              @collection = global_filter
            end

            @request.searching.filters.each do |column_filter|
              next unless column_filter.searchable
              @collection = filter_by(column_filter)
            end

            @collection
          end
        end
      end

      def global_filter
        call_overridden_or_block(__method__, @collection,
                                 @request.searching.global_filter.search,
                                 @request.searching.global_filter.regexp) do
          @collection_adapter.global_filter(@collection, @request.searching.global_filter)
        end
      end

      def filter_by(column_filter)
        call_overridden_or_block(__method__, @collection, column_filter) do
          call_overridden_or_block("filter_by_#{column_filter.column.name}", @collection,
                                   column_filter.search, column_filter.regexp) do
            @collection_adapter.filter_by(@collection, column_filter)
          end
        end
      end

      def sort
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request.sorting) do
            @request.sorting.columns.each do |column_order|
              next unless column_order.sortable
              @collection = sort_by(column_order)
            end

            @collection
          end
        end
      end

      def sort_by(column_order)
        call_overridden_or_block(__method__, @collection, column_order) do
          call_overridden_or_block("sort_by_#{column_order.column.name}", @collection,
                                   column_order.direction) do
            @collection_adapter.sort_by(@collection, column_order)
          end
        end
      end

      def paginate
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request.pagination) do
            @collection_adapter.paginate(@collection, @request.pagination)
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