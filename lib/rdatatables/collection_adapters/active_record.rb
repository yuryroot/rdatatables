module RDataTables
  module CollectionAdapters
    class ActiveRecord < Core::CollectionAdapter

      class << self
        def processable?(collection)
          defined?(::ActiveRecord) && collection.is_a?(::ActiveRecord::Relation)
        end

        def sort_by(collection, column, direction)
          collection.order(column => direction)
        end

        def paginate(collection, start_from, per_page)
          collection.offset(start_from).limit(per_page)
        end
      end
    end
  end
end