require File.expand_path('../../test_helper', __FILE__)

class AttachedDocumentsControllerTest < ActionController::TestCase

  def setup
    User.current = nil
    @user = build(:admin)
    #User.stubs(:current).at_least_once.returns(user)
    #user.stubs(:allowed_to?).returns(true)
    @request.session[:user_id] = @user.id
    @project = create(:project)
    @user.stubs(:project).returns(@project)
  end

  def teardown
    @user.destroy
    @project.destroy
  end

  def test_get_index
    create(:attached_document)
    get :index, :project_id => @project.id
    assert_response :success
    assert_not_nil assigns(:documents), "No documents assigned #{assigns.inspect}"

  end
end
