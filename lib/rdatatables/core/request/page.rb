module RDataTables
  module Core
    class Request
      class Page
        attr_reader :start_from
        attr_reader :per_page
        attr_reader :page

        def initialize(params:)
          @start_from = Integer(params.fetch('iDisplayStart'))
          @per_page   = Integer(params.fetch('iDisplayLength'))
          @page       = @start_from / @per_page + 1
        end
      end
    end
  end
end