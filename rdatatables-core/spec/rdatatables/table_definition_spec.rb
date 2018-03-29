RSpec.describe 'table definition' do

  context 'independent table' do
    let(:table) do
      Class.new(RDataTables::Table)
    end

    it 'no default columns' do
      expect(table.columns).to be_empty
    end

    it 'appends new columns' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
    end

    it 'appends :before other' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
      table.column :before_second_column, before: :second_column
      expect(table.columns.map(&:name)).to eq([:first_column, :before_second_column, :second_column])
    end

    it 'appends :after other' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
      table.column :after_first_column, after: :first_column
      expect(table.columns.map(&:name)).to eq([:first_column, :after_first_column, :second_column])
    end

    it 'appends :instead_of other' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
      table.column :replaced_second_column, instead_of: :second_column
      expect(table.columns.map(&:name)).to eq([:first_column, :replaced_second_column])
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

  context 'instance columns' do
    let(:table) do
      Class.new(RDataTables::Table)
    end

    it 'same with class columns by default' do
      table.column :first_column
      table.column :second_column

      expect(table.columns.map(&:name)).to eq([:first_column, :second_column])
      expect(table.new.columns.map(&:name)).to eq([:first_column, :second_column])
    end

    it "option :if_func works" do
      table.column :first_column, if_func: -> { true }
      table.column :second_column, if_func: -> { false }

      expect(table.new.columns.map(&:name)).to eq([:first_column])
    end

    it "option :unless_func works" do
      table.column :first_column, unless_func: -> { false }
      table.column :second_column, unless_func: -> { true }

      expect(table.new.columns.map(&:name)).to eq([:first_column])
    end

    it "both :if_func and :unless_func work together" do
      table.column :first_column, if_func: -> { true }, unless_func: -> { false }
      table.column :second_column, if_func: -> { false }, unless_func: -> { false }
      table.column :third_column, if_func: -> { true }, unless_func: -> { true }

      expect(table.new.columns.map(&:name)).to eq([:first_column])
    end
  end
end
