module RDataTables
  module Collections
  end
end

%w(active_record).each do |adapter|
  require_relative "collections/#{adapter}"
end