require File.expand_path('../../test_helper', __FILE__)

class CompaniesControllerTest < ActionController::TestCase

  def setup
    User.current = nil
    user = User.first || create(:admin)
    #User.stubs(:current).at_least_once.returns(user)
    #user.stubs(:allowed_to?).returns(true)
    @request.session[:user_id] = user.id
    @project = create(:project)
    user.stubs(:project).returns(@project)
  end

  def should_get_index
    get :index, project_id: @project.id
    assert_response :success
    assert_not_nil assigns(:companies)
  end

end
