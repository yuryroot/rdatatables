module RDataTables
end

%w(version core collections).each do |script|
  require_relative "rdatatables/#{script}"
end
