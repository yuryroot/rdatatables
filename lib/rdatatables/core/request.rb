%w(meta page sorting column_order).each do |entity|
  require_relative "request/#{entity}"
end

module RDataTables
  module Core
    class Request
      attr_reader :meta
      attr_reader :page
      attr_reader :sorting

      def initialize(table:, params:)
        @meta    = Meta.new(params: params)
        @page    = Page.new(params: params)
        @sorting = Sorting.new(params: params, table: table)
      end
    end
  end
end