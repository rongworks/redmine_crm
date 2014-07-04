require File.expand_path('../../test_helper', __FILE__)

class ClientsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def should_get_index
    get :index
    assert_response :success
  end

  def test_post_create_with_attachment
    set_tmp_attachments_directory
    user = create(:admin)
    test_project = create(:project)
    User.expects(:current).at_least_once.returns(user)

    assert_difference 'Client.count' do
      assert_difference 'Attachment.count', +1  do
        post :create, :project_id => test_project.id,
             :client => build(:contact).attributes,
             :attachments => {'1' => {'file' => mock_file_with_options(:original_filename => 'upload')}}
      end
    end

  end

end
