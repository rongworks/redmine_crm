require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase

  def setup
    User.current = nil
    @user = build(:admin)
    #User.stubs(:current).at_least_once.returns(user)
    #user.stubs(:allowed_to?).returns(true)
    @request.session[:user_id] = @user.id
    @project = create(:project)
    @user.stubs(:project).returns(@project)
    @client = create(:contact)
  end

  def teardown
    @user.destroy
    @project.destroy
    @client.destroy
  end

  def test_should_get_index
    get :index, :project_id => @project.id
    assert_not_nil assigns(:clients), "No clients assigned #{assigns.inspect}"
    assert_response :success
  end

  test 'should show client' do
    get :show, {id: @client.id, :project_id => @project.id}
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_response(:success, "expected success, but got: #{@response.body}")
  end

  test 'should show edit form for client' do
    get :edit, {id: @client.id, :project_id => @project.id}
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_response :success, "expected success, but got: #{@response.body}"

  end

  test 'should update client' do
    assert_equal @client, Client.find(@client.id)
    post :update, id: @client.id, project_id: @project.id, client: {first_name: 'Peter'}
    assert_redirected_to client_path(id: @client.id),"expected redirect to client, but got: #{response.body}"
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_equal 'Peter', Client.find(@client.id).first_name, "Name should have changed to Peter, but was #{Client.find(@client.id).first_name}, flash: #{flash.map{|k,v| "#{k}:#{v}"}}"
  end

end
