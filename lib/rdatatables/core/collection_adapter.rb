module RDataTables
  module Core
    class CollectionAdapter

      class << self
        def processable?(collection)
          false
        end

        def data_cell(object, column)
          object.public_send(column.name)
        end

        def sort_by(collection, column_order)
          collection
        end

        def paginate(collection, pagination)
          collection
        end
      end
    end
  end
end