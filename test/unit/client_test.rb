require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < ActiveSupport::TestCase

  plugin_fixtures :clients

  test 'should fail' do
    assert false
  end

  test 'should save valid client' do
    client = build(:contact)
    assert  client.save
  end

  test 'should not save client without last_name' do
    client = clients(:client_no_last_name)
    assert_not client.save
  end

  test 'should be commentable' do
    client = clients(:client_no_last_name)
    client.save
    comment = crmcomments(:valid_comment)
    assert comment.save, "comment should have been saved"
    assert client.crmcomments.include?(comment), "Client should reference new comment"
  end

end
