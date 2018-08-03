module RDataTables
  class Table
    class HtmlHeaderAttributesBuilder

      def initialize
        @data = {}
      end

      def __register_column__(object)
        name = object.name

        @data[name] = {
          column: object,
          attributes: build_attributes_for(object),
          content: name.to_s
        }
      end

      def __columns_data__
        @data.values
      end

      def method_missing(method, *args, &block)
        column_data = @data[method.to_sym]

        if column_data
          original_attributes = column_data[:attributes]
          new_attributes = args.first
          column_data[:attributes] = merge_attributes(original_attributes, new_attributes)
          column_data[:content] = block.call if block_given?
        else
          super
        end
      end

      def respond_to?(method, include_private = nil)
        @data.key?(method.to_sym) || super
      end

      private

      def build_attributes_for(column)
        data = {
          sortable:   column.sortable?,
          searchable: column.searchable?
        }

        { data: data }
      end

      def merge_attributes(original, additional)
        merged = Helpers.clone_object(original)

        additional = Helpers.clone_object(additional)
        additional = Helpers.symbolize_keys(additional)

        extra_data = additional.delete(:data)
        if extra_data
          merged[:data].merge!(extra_data)
        end

        merged.merge!(additional)
      end
    end
  end
end
