module RDataTables
  module Collections
    class ActiveRecord < RDataTables::Core::Collection

      def _data_cell(object, column)
        object.send(column)
      end

      def _filter
        @collection
      end

      def _sort_by(column, direction)
        @collection.order(column => direction)
      end

      def _paginate
        from, per = @request.pagination_info.values_at(:start_from, :per_page)
        @collection.offset(from).limit(per)
      end
    end
  end
end