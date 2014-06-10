require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def should_get_index
    get :index
    assert_response :success
  end
end
