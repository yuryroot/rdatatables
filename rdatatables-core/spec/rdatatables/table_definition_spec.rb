RSpec.describe 'table definition' do

  context 'independent table' do
    let(:table) do
      Class.new(RDataTables::Table)
    end

    it 'no default columns' do
      expect(table.columns).to be_empty
    end

    it 'defines new columns' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
    end

    it 'prevents duplicate columns' do
      table.column :some_column

      expect { table.column :some_column }.to raise_error(/Column 'some_column' already exists/)
    end
  end

  context 'with inheritance' do
    let :parent_table do
      Class.new(RDataTables::Table)
    end

    let :child_table do
      Class.new(parent_table)
    end

    it 'child table inherits parent columns' do
      parent_table.column :first_parent_column
      parent_table.column :second_parent_column

      expect(child_table.columns.map(&:name)).to eq([:first_parent_column, :second_parent_column])
    end

    it "child table manipulations don't affect parent table" do
      expect(parent_table.columns).to be_empty

      child_table.column :some_column

      expect(child_table.columns.map(&:name)).to eq([:some_column])
      expect(parent_table.columns).to be_empty
    end
  end
end
