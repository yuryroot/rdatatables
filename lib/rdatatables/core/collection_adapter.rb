module RDataTables
  module Core
    class CollectionAdapter

      class << self
        def processable?(collection)
          false
        end

        def data_cell(object, column)
          object.public_send(column)
        end

        def filter(collection)
          collection
        end

        def sort_by(collection, column, direction)
          collection
        end

        def paginate(collection, start_from, per_page)
          collection
        end
      end
    end
  end
end