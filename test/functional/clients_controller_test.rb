require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase

  def setup
    User.current = nil
    @user = create(:admin)
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

  def should_get_index
    get :index, :project_id => @project.id
    assert_not_nil assigns(:clients), "No clients assigned #{assigns.inspect}"
    assert_response :success
  end

  test 'should show client' do
    client = create(:contact)
    get :show, {id: client.id, :project_id => @project.id}
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_response(:success, "expected success, but got: #{@response.body}")

  end

  test 'should show edit form for client' do

    client = create(:contact)
    get :edit, {id: client.id, :project_id => @project.id}
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_response :success, "expected success, but got: #{@response.body}"

  end

  test 'should update client' do
    client = create(:contact)
    post :update, id: client.id, project_id: @project.id, client: {first_name: 'Peter'}
    assert_redirected_to client_path(id: client.id),"expected redirect to client, but got: #{response.body}"
    assert_not_nil assigns(:client), "No client assigned #{assigns.inspect}"
    assert_equal 'Peter', Client.find(client.id).first_name, "Name should have changed to Peter, but was #{Client.find(client.id).first_name}, #{Client.find(client.id).inspect}"
  end

  def test_post_update_with_attachment
    set_tmp_attachments_directory
    client = create(:contact)
    client.stubs(:project).returns(@project)

    assert_difference 'client.attachments.count' do
      assert_difference 'Attachment.count', +1  do
        post :update, :project_id => @project.id,
             :id => client.id,
             :attachments => {'1' => {'file' => mock_file_with_options(:original_filename => 'upload')}}
      end
    end
  end

end
