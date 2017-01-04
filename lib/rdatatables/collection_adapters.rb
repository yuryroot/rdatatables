%w(active_record).each do |adapter|
  require_relative "collection_adapters/#{adapter}"
end

module RDataTables
  module CollectionAdapters
    ADAPTERS = [ActiveRecord].freeze

    def self.adapter_for(collection)
      adapter = ADAPTERS.find { |adapter| adapter.processable?(collection) }
      adapter || raise(RDataTables::CollectionNotSupported, collection.class.name)
    end
  end
end
