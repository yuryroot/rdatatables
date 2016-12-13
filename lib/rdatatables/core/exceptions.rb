module RDataTables
  module Core
    module Exceptions

      class RDataTablesError < Exception
      end

      class DuplicateColumn < RDataTablesError
      end

      class CollectionNotSupported < RDataTablesError
      end
    end
  end
end