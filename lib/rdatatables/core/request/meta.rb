module RDataTables
  module Core
    class Request
      class Meta
        attr_reader :echo

        def initialize(params:)
          @echo = Integer(params.fetch('sEcho'))
        end
      end
    end
  end
end