module RDataTables
  module Core
    class Collection
      
      def initialize(table:, collection:, request:)
        @table = table
        @collection = collection
        @request = request
      end

      def self.processable?(collection)
        false
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
          _data_cell(object, column)
        end
      end

      def filter
        @collection = begin
          call_overridden_or_block(__method__, @collection, @request) do
            _filter
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
            sort_method = "sort_by_#{column}"
            
            if overridden?(sort_method)
              @table.send(sort_method, @collection, column, direction)
            else
              _sort_by(column, direction)
            end
          end
        end
      end

      def paginate
        @Collection = begin
          call_overridden_or_block(__method__, @collection, @request) do
            _paginate
          end
        end
      end

      protected

      %w(_data_cell _filter _sort_by _paginate).each do |method|
        define_method(method) do
          raise NotImplementedError, method
        end
      end

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