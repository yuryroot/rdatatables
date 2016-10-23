%w(version table request collection).each do |script|
  require "rdatatables/#{script}"
end

module RDataTables
end
