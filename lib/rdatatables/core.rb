module RDataTables
  module Core
  end
end

%w(table request collection).each do |script|
  require_relative "core/#{script}"
end