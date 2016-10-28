module RDataTables
  module Core
    module Table
      DuplicateColumn = Class.new(Exception)

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
            raise DuplicateColumn, name
          end

          columns[name] = options
        end
      end

      def initialize(*args)
        initialize_table(*args)
      end

      def initialize_table(collection: [], request_params: {}, context: nil)
        @request = Request.new(table: self, params: request_params)
        @collection = Collection.new(table: self, collection: collection, request: @request)
        @context = context
      end
    end
  end
end  