%w(meta pagination searching sorting).each do |entity|
  require_relative "request/#{entity}"
end

module RDataTables
  module Core
    class Request
      attr_reader :meta
      attr_reader :pagination
      attr_reader :searching
      attr_reader :sorting

      def initialize(table:, params:)
        @meta       = Meta.new(params: params)
        @pagination = Pagination.new(params: params)
        @searching  = Searching.new(params: params, table: table)
        @sorting    = Sorting.new(params: params, table: table)
      end
    end
  end
end