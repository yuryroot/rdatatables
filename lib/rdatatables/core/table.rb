require_relative 'table/column'

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
            class_variable_set(:@@columns, [])
          end
        end

        def column(name, options = {})
          column = Column.new(name, options)

          if columns.include?(column)
            raise(RDataTables::DuplicateColumn, name)
          else
            columns << column
          end
        end
      end

      attr_reader :context

      def initialize(*args)
        initialize_table(*args)
      end

      def initialize_table(collection:, request_params: {}, context: nil)
        @request = Request.new(table: self, params: request_params)
        @processor = Processor.new(table: self, collection: collection, request: @request)
        @context = context
      end

      def response_hash
        @processor.process
        @processor.data_hash
      end
    end
  end
end
