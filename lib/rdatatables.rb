module RDataTables
end

%w(version core collection_adapters).each do |script|
  require_relative "rdatatables/#{script}"
end
