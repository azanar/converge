require File.expand_path('../../../../test_helper', __FILE__)

require 'converge/db/table/target'

class Converge::DB::Table::BaseTest < Test::Unit::TestCase
  setup do
    @mock_model = mock

    @base = Class.new do
      include Converge::DB::Table::Base
    end

    @table = @base.new(@mock_model)
  end

  test '#name' do
    mock_columns = mock
    @mock_model.expects(:columns).returns(mock_columns)
    
    res = @table.columns
    assert_equal res, mock_columns
  end
end

