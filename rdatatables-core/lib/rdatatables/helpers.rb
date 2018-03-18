module RDataTables
  module Helpers
    def symbolize_keys(hash)
      hash.map { |option, value| [option.to_sym, value] }.to_h
    end

    extend self
  end
end