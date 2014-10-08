require File.expand_path('../../../../test_helper', __FILE__)

require 'converge/db/table/merger'

class Converge::DB::Table::MergerTest < Test::Unit::TestCase
  setup do
    @connection = mock
  end
  test '#merger' do
    mock_date_range = mock

    mock_target_table = mock
    mock_staging_table = mock

    mock_conn_staging_table = mock 
    mock_conn_target_table = mock

    mock_conn_target_table.expects(:update).with(mock_conn_staging_table)
    mock_conn_target_table.expects(:insert).with(mock_conn_staging_table)
    mock_conn_target_table.expects(:finalize)

    @connection.expects(:table).with(mock_staging_table).returns(mock_conn_staging_table)
    @connection.expects(:table).with(mock_target_table).returns(mock_conn_target_table)

    merger = Converge::DB::Table::Merger.new(mock_staging_table, @connection)
    merger.merge(mock_target_table)
  end
end
