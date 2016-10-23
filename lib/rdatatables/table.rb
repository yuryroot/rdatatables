module RDataTables
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

    %w(filter sort paginate data_hash data_rows).each do |method|
      define_method(method) do
        @collection.send(method)
      end
    end

    def initialize(*args)
      initialize_table(*args)
    end

    def initialize_table(collection: [], request_params: {}, context: nil)
      @request = Request.new(table_object: self, request_params: request_params)
      @collection = Collection.new(table_object: self, collection: collection, request: @request)
      @context = context
    end

    def response_hash
      filter
      sort
      paginate
      data_hash
    end
  end
end