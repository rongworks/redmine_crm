require File.expand_path('../../test_helper', __FILE__)

class ClientTest < ActiveSupport::TestCase

  test 'should save valid client' do
    client = build(:contact)
    assert client.save
  end

  test 'should not save client without last_name' do
    client = build(:contact)
    assert client.valid?, 'base client should be valid'
    client.last_name = nil
    assert !client.save, 'should not save client without last_name'
  end

  test 'should be commentable' do
    client = build(:contact)
    client.save
    comment = build(:comment)
    comment.commentable = client
    assert comment.save, 'comment should have been saved'
    assert client.crmcomments.include?(comment), 'Client should reference new comment'
  end

  test 'should save attachments' do
    #mock setup
    set_tmp_attachments_directory
    user = create(:admin)
    project = create(:project)
    client = create(:contact)
    client.stubs(:project).returns(project)
    User.expects(:current).returns(user)

    assert_difference 'client.attachments.count',3 do
      client.save_attachments({
                                 'p0' => {'file' => mock_file_with_options(:original_filename => 'upload')},
                                 '3' => {'file' => mock_file_with_options(:original_filename => 'bar')},
                                 '1' => {'file' => mock_file_with_options(:original_filename => 'foo')}
                             })
      client.attach_saved_attachments
    end
  end



end
