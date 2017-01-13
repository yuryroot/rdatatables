%w(active_record enumerable).each do |adapter|
  require_relative "collection_adapters/#{adapter}"
end

module RDataTables
  module CollectionAdapters
    ADAPTERS = [ActiveRecord, Enumerable].freeze

    def self.adapter_for(collection)
      adapter = ADAPTERS.find { |adapter| adapter.processable?(collection) }
      adapter || raise(RDataTables::CollectionNotSupported, collection.class.name)
    end
  end
end
