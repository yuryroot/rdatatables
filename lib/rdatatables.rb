module RDataTables
end

%w(version core).each do |script|
  require_relative "rdatatables/#{script}"
end
