require File.expand_path('../../../../test_helper', __FILE__)

require 'converge/db/table/target'

class Converge::DB::Table::TargetTest < Test::Unit::TestCase
  setup do
    @mock_model = mock
    @target = Converge::DB::Table::Target.new(@mock_model)
  end
end
