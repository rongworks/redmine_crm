require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase

  def setup
    user = build(:admin)
    User.expects(:current).at_least_once.returns(user)
  end

  def should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test 'should show client' do
    client = create(:contact)
    get :show, id: client.id
    assert_not_nil assigns(client)
    puts @response.inspect
    assert_response(:success, "expected success, but got: #{@response.body}")

  end

  test 'should show edit form for client' do

    client = create(:contact)
    get :edit, id: client.id
    assert_response :success, "expected success, but got: #{@response.body}"
    assert_not_nil assigns(client)
  end

  test 'should update client' do
    client = create(:contact)
    post :update, {id: client.id, first_name: 'Peter'}
    assert_redirected_to client_path(id: client.id),"expected redirect to client, but got: #{response.body}"
    assert_not_nil assigns(:client)
    assert_equals client.first_name, 'Peter'
  end

  def test_post_update_with_attachment
    set_tmp_attachments_directory
    client = create(:contact)
    test_project = create(:project)
    client.stubs(:project).returns(test_project)

    assert_difference 'client.attachments.count' do
      assert_difference 'Attachment.count', +1  do
        post :update, :project_id => test_project.id,
             :id => client.id,
             :attachments => {'1' => {'file' => mock_file_with_options(:original_filename => 'upload')}}
      end
    end
  end

end
