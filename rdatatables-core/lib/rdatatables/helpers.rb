module RDataTables
  module Helpers
    def symbolize_keys(hash)
      hash.map { |option, value| [option.to_sym, value] }.to_h
    end

    def clone_object(object)
      Marshal.load(Marshal.dump(object))
    end

    extend self
  end
end