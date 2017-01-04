%w(exceptions table request processor collection_adapter).each do |script|
  require_relative "core/#{script}"
end

module RDataTables
  include Core::Exceptions

  module Core
  end
end
