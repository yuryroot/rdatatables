module RDataTables
  module Core
    module Table
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def columns
          if class_variable_defined?(:@@columns)
            class_variable_get(:@@columns)
          else
            class_variable_set(:@@columns, {})
          end
        end

        def column(name, options = {})
          if columns.key?(name)
            raise(RDataTables::DuplicateColumn, name)
          end

          columns[name] = options
        end
      end

      def initialize(*args)
        initialize_table(*args)
      end

      def initialize_table(collection:, request_params: {}, context: nil)
        @request = Request.new(table: self, params: request_params)
        @context = context

        collection_adapter = Collections.adapter_for(collection)
        @collection = collection_adapter.new(table: self, collection: collection, request: @request)
      end
    end
  end
end  