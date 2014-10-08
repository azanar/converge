require File.expand_path('../test_helper', __FILE__)

require File.expand_path('../db_test_helper', __FILE__)

require File.expand_path('../mock_adapter', __FILE__) 

require 'converge'

require 'active_support'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/time/calculations'

class Converge::IntegrationTest < Test::Unit::TestCase
  include Converge::DBTestHelper

  setup do
    @columns= %w{id mock_col_1 mock_col_2}
    @target_name = "mock_models"
    @staging_name = "mock_models_staging"

    @mock_socket = mock
    @mock_db = Converge::Mock::Connection.new(@mock_socket)
    @connection = Converge::DB::Connection.new(@mock_db)

    @mock_config = mock

    @mock_config.expects(:columns).at_least_once.returns(@columns)

    @mock_model = mock
    @mock_model.expects(:table_name).at_least_once.returns(@target_name)

    @model = Converge::Model.new(@mock_config, @mock_model)

    @mock_table_object_collection = mock

    @concrete_staging_table = mock
    @concrete_target_table = mock
  end

  test 'standard table load' do
    progress = states('progress').starts_as('start')

    staging_table = Converge::DB::Table::Staging.new(@model)
    conn_staging = @connection.table(staging_table)

    target_table = Converge::DB::Table::Target.new(@model)

    @mock_socket
      .expects(:run_command)
      .when(progress.is('start'))
      .with(
        :cmd => "copy", 
        :objects => @mock_table_object_collection
      ).then(progress.is('loaded'))

    @mock_socket.expects(:run_command)
      .when(progress.is('loaded'))
      .with(
        :cmd => "update",
        :source => @staging_name,
        :destination => @target_name,
        :columns => @columns
      ).then(progress.is('updated'))

    @mock_socket.expects(:run_command)
      .when(progress.is('updated'))
      .with(
        :cmd => "insert",
        :source => @staging_name,
        :destination => @target_name,
        :columns => @columns
      ).then(progress.is('inserted'))

    @mock_socket.expects(:run_command)
      .when(progress.is('inserted'))
      .with(
        :cmd => "finalize"
      ).then(progress.is('finalized'))


    conn_staging.copy(@mock_table_object_collection)

    merger = Converge::DB::Table::Merger.new(staging_table, @connection)
    merger.merge(target_table)

    assert progress.is('finalized')
  end
end
