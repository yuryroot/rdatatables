module RDataTables
  module CollectionAdapters
    class ActiveRecord < Core::CollectionAdapter

      class << self
        def processable?(collection)
          defined?(::ActiveRecord) && collection.is_a?(::ActiveRecord::Relation)
        end

        # TODO: Implement global filtration for AR
        def global_filter(collection, global_filter)
          collection
        end

        # TODO: Implement filtration by column for AR
        def filter_by(collection, column_filter)
          collection
        end

        def sort_by(collection, column_order)
          collection.order(column_order.column.name => column_order.direction)
        end

        def paginate(collection, pagination)
          collection.offset(pagination.start_from).limit(pagination.per_page)
        end
      end
    end
  end
end