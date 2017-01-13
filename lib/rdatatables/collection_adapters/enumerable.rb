module RDataTables
  module CollectionAdapters
    class Enumerable < Core::CollectionAdapter

      class << self
        def processable?(collection)
          collection.is_a?(::Enumerable)
        end

        def sort_by(collection, column, direction)
          sorted_collection = collection.sort_by { |object| data_cell(object, column) }
          direction == 'asc' ? sorted_collection : sorted_collection.reverse
        end

        def paginate(collection, start_from, per_page)
          collection[start_from, per_page]
        end
      end
    end
  end
end