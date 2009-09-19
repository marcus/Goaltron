require File.dirname(__FILE__) + '/../test_helper'
require 'personal_indicators_controller'

# Re-raise errors caught by the controller.
class PersonalIndicatorsController; def rescue_action(e) raise e end; end

class PersonalIndicatorsControllerTest < Test::Unit::TestCase
  def setup
    @controller = PersonalIndicatorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
