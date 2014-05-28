require File.expand_path('../../test_helper', __FILE__)

class ClientTest < ActiveSupport::TestCase

  test 'should save valid client' do
    client = build(:contact)
    assert  client.save
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

end
