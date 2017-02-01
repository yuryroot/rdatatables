module RDataTables
  module Core
    class Processor
      
      def initialize(table:, collection:, request:)
        @table = table
        @collection = collection
        @collection_adapter = CollectionAdapters.adapter_for(collection)
        @request = request
      end

      def process
        filter
        sort
        paginate
      end

      def data_hash
        {
          sEcho:                @request.meta.echo,
          iTotalRecords:        @collection.count,  # TODO: Implement filtration
          iTotalDisplayRecords: @collection.count,  # TODO: Implement filtration
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
              call_overridden_or_block('global_filter', @collection,
                                        @request.searching.global_filter.search,
                                        @request.searching.global_filter.regexp) do
                @collection = @collection_adapter.global_filter(@collection, @request.searching.global_filter)
              end
            end

            @request.searching.filters.each do |column_filter|
              @collection = filter_by(column_filter)
            end

            @collection
          end
        end
      end

      # TODO: check searchable parameter
      def filter_by(column_filter)
        @collection = begin # TODO: Doesn't this assignment make sense?
          call_overridden_or_block(__method__, @collection, column_filter) do
            call_overridden_or_block("filter_by_#{column_filter.column.name}", @collection,
                                     column_filter.search, column_filter.regexp) do
              @collection_adapter.filter_by(@collection, column_filter)
            end
          end
        end
      end

      def sort
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request.sorting) do
            @request.sorting.columns.each do |column_order|
              @collection = sort_by(column_order)
            end

            @collection
          end
        end
      end

      # TODO: check sortable parameter
      def sort_by(column_order)
        @collection = begin # TODO: Doesn't this assignment make sense?
          call_overridden_or_block(__method__, @collection, column_order) do
            call_overridden_or_block("sort_by_#{column_order.column.name}", @collection,
                                     column_order.direction) do
              @collection_adapter.sort_by(@collection, column_order)
            end
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