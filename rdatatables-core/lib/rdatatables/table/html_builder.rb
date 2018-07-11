# TODO: cover by tests
# TODO: title, value + I18n

module RDataTables
  class Table
    class HtmlBuilder

      def initialize(table_instance)
        @table = table_instance
      end

      class HeaderBuilder

        def initialize
          @data = {}
        end

        def __register_column__(object)
          name = object.name
          @data[name] = { column: object, html: build_attributes_for(object) }
        end

        def method_missing(method, *args)
          column_data = @data[method.to_sym]

          if column_data
            original_attributes = column_data[:html]
            new_attributes = args.first
            column_data[:html] = merge_attributes(original_attributes, new_attributes)
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
            sort:   column.sortable?,
            search: column.searchable?
          }

          { data: data, title: nil, value: nil }
        end

        def merge_attributes(original, additional)
          merged = Helpers.clone_object(original)
          additional = Helpers.symbolize_keys(additional)

          extra_data = additional.delete(:data)
          if extra_data
            merged[:data].merge!(extra_data)
          end

          merged.merge!(additional)
        end
      end

      def build_header(&block)
        builder = HeaderBuilder.new

        @table.columns.each do |column|
          builder.__register_column__(column)
        end

        if block_given?
          block.call(builder)
        end

        build_header_html(builder)
      end

      private

      def build_header_html(builder)
        raise NotImplementedError
      end
    end
  end
end
