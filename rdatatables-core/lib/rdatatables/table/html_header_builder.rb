module RDataTables
  class Table
    class HtmlHeaderBuilder

      def initialize(table_instance)
        @table = table_instance
      end

      def build_header(&block)
        builder = HtmlHeaderAttributesBuilder.new

        @table.columns.each do |column|
          builder.__register_column__(column)
        end

        if block_given?
          block.call(builder)
        end

        build_html(builder)
      end

      private

      def build_html(builder)
        columns_data = builder.__columns_data__

        html = ::Builder::XmlMarkup.new
        
        html.thead do
          html.tr do
            columns_data.each do |data|
              attributes = {}

              data.fetch(:attributes).each do |attribute, value|  
                if attribute == :data
                  value.each do |data_attribute, data_value|  
                    attribute_name = "data-#{data_attribute}"
                    attributes[to_attribute_name(attribute_name)] = data_value
                  end
                else
                  attributes[to_attribute_name(attribute)] = value
                end
              end

              content = data.fetch(:content)
              html.th(attributes) { |tag| tag << content }
            end
          end
        end
      end

      def to_attribute_name(value)
        value.to_s.gsub('_', '-')
      end
    end
  end
end
