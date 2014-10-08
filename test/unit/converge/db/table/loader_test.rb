require File.expand_path('../../../../test_helper', __FILE__)

require 'converge/db/table/loader'

class Converge::DB::Table::LoaderTest < Test::Unit::TestCase
  setup do
    @test_host = "redshift-test.sjc.carrel.org"
    @test_table = "mock_table"
    @test_staging_table = "#{@test_table}_staging"

    @mock_connection = mock
    @mock_table = mock
    #@mock_table.expects(:name).at_least_once.returns(@test_table)
    #@mock_table.expects(:columns).at_least_once.returns(%w{id mock_col_1 mock_col_2})

    @loader = Converge::DB::Table::Loader.new(@mock_table, @mock_connection)
  end

  test '#load' do
    mock_object_collection = mock

    @mock_table.expects(:truncate)
    @mock_table.expects(:copy).with(mock_object_collection)

    @loader.load(mock_object_collection)
  end

  test '#finalize once' do
    state = states('loader_state').starts_as('unclean')

    mock_object_collection = mock
    @mock_table.expects(:truncate).
                when(state.is('unclean')).
                then(state.is('clean'))

    @mock_table.expects(:copy).
                when(state.is('clean')).
                with(mock_object_collection).
                then(state.is('copied'))

    @mock_table.expects(:truncate).
                when(state.is('copied')).
                then(state.is('done'))

    @loader.load(mock_object_collection)
    @loader.finalize
  end

  test '#finalize twice should only run once' do
    state = states('loader_state').starts_as('unclean')
    mock_object_collection = mock

    @mock_table.expects(:truncate).
                when(state.is('unclean')).
                then(state.is('clean'))

    @mock_table.expects(:copy).
                when(state.is('clean')).
                with(mock_object_collection).
                then(state.is('copied'))

    @mock_table.expects(:truncate).
                when(state.is('copied')).
                then(state.is('done'))

    @loader.load(mock_object_collection)
    @loader.finalize
    @loader.finalize
  end

  test '#finalize should be allowed if the table has not be touched yet' do
    @mock_table.expects(:truncate)
    @loader.finalize
  end
end
