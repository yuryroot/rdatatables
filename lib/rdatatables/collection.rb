# TODO: check if overrides are implemented in table object

module RDataTables
  class Collection

    def initialize(collection: [], table_object:, request:)
      @collection = collection
      @table_object = table_object
      @request = request
    end

    def data_hash
      {
        sEcho:                @request.echo,
        iTotalRecords:        @all_records_count,
        iTotalDisplayRecords: @filtered_records_count,
        aaData:               data_rows
      }
    end

    def data_rows
      @collection.map { |object| data_row(object) }
    end

    def data_row(object)
      @table_object.class.columns.keys.map do |column|
        if @table_object.respond_to?(column)
          @table_object.send(column, object)

        elsif object.is_a?(Hash)
          object[column.to_sym] || object[column.to_s]

        elsif object.respond_to?(column)
          object.send(column)

        else
          nil
        end
      end
    end

    def filter
      @all_records_count = @filtered_records_count = @collection.count
    end
    
    def sort
      return if @request.sorting_columns.empty?

      if ar_relation?
        @request.sorting_columns.each do |column, direction|
          sort_method = "order_by_#{column}"

          if @table_object.respond_to?(sort_method)
            @collection = @table_object.send(sort_method, @collection, direction)
          else
            @collection = @collection.order(column => direction)
          end
        end
      
      else
        raise NotImplementedError
      end
    end

    def paginate
      if ar_relation?
        info = @request.pagination_info
        @collection = @collection.offset(info[:start_from]).limit(info[:per_page])

      else
        raise NotImplementedError
      end
    end

    private

    def ar_relation?
      defined?(ActiveRecord::Base) && @collection.is_a?(ActiveRecord::Relation)
    end

    def ds_relation?
      defined?(Sequel::Dataset) && @Collection.is_a?(Sequel::Dataset)
    end

    def enumerable?
      @collection.is_a?(Enumerable)
    end
  end
end