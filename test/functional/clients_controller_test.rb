require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def should_get_index
    get :index
    assert_response :success
  end

  def test_post_update_with_attachment
    set_tmp_attachments_directory
    client = create(:contact)
    user = create(:admin)
    test_project = create(:project)
    User.expects(:current).at_least_once.returns(user)
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
