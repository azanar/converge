require File.expand_path('../../../../../test_helper', __FILE__)

require 'converge/aws/redshift/db/table_collection'

class Converge::AWS::Redshift::DB::TableCollection::MergerTest < Test::Unit::TestCase
  setup do
    @connection = mock
  end
  test '#merger' do
    mock_date_range = mock

    mock_staging_table = mock
    mock_staging_table.expects(:date_range).returns(mock_date_range)

    mock_tables = 5.times.map { 
      mock_table = mock 
      mock_table.expects(:load).with(mock_staging_table)
      mock_table.expects(:finalize)
      mock_table
    }

    mock_table_collection = mock
    mock_table_collection.expects(:tables_for_date_range).with(mock_date_range).returns(mock_tables)

    merger = Converge::AWS::Redshift::DB::TableCollection::Merger.new(mock_table_collection, @connection)
    merger.merge(mock_staging_table)
  end
end
class Converge::AWS::Redshift::DB::TableCollectionTest < Test::Unit::TestCase
  setup do
    @connection = mock
    
    @mock_model = mock

    @collection = Converge::AWS::Redshift::DB::TableCollection.new(@mock_model, @connection)
  end

  test '#tables_for_date_range no partition' do
    mock_table = mock
    mock_date_range = mock

    @mock_model.expects(:partition?).returns(false)

    Converge::AWS::Redshift::DB::Table.expects(:new).with(@mock_model, @connection).returns(mock_table)
    Converge::AWS::Redshift::DB::TableWithMonthlyPartition.expects(:from_date_range).never

    result = @collection.tables_for_date_range(mock_date_range)

    assert_equal result, [mock_table]
  end

  test '#tables_for_date_range partition' do

    mock_date_range = mock
    mock_tables = 5.times.map { mock }

    @mock_model.expects(:partition?).returns(true)

    Converge::AWS::Redshift::DB::TableWithMonthlyPartition.expects(:from_date_range).with(@mock_model, @connection, mock_date_range).returns(mock_tables)
    Converge::AWS::Redshift::DB::Table.expects(:new).never

    collection = Converge::AWS::Redshift::DB::TableCollection.new(@mock_model, @connection)

    result = collection.tables_for_date_range(mock_date_range)

    assert_equal result, mock_tables
  end

end
