module RDataTables
  module CollectionAdapters
    class ActiveRecord < Core::CollectionAdapter

      class << self
        def processable?(collection)
          defined?(::ActiveRecord) && collection.is_a?(::ActiveRecord::Relation)
        end

        def sort_by(collection, column_order)
          collection.order(column_order.column => column_order.direction)
        end

        def paginate(collection, page)
          collection.offset(page.start_from).limit(page.per_page)
        end
      end
    end
  end
end