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

        def filter_by(collection, column_filter)
          column_name = column_filter.column.name
          column_info = collection.columns_hash[column_name]

          condition = begin
            # TODO: Check all types in ActiveModel::Type module.
            if %i(text string).include?(column_info.type)
              collection.arel_table[column_name].matches("%#{column_filter.search.strip}%")
            else
              # TODO: Build more intellectual condition for integers, dates, etc.
              #       Also fix errors of these types.
              { column_name => collection.connection.type_cast(column_filter.search, column_info) }
            end
          end

          collection.where(condition)
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