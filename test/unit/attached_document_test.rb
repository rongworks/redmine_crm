require File.expand_path('../../test_helper', __FILE__)

class AttachedDocumentTest < ActiveSupport::TestCase

  def setup
    @doc = build(:attached_document)
    @tmp_file = Tempfile.new('foo')
    @uploader = DocumentUploader.new(@doc,:file)

  end

  def teardown
    @uploader.remove!
    @tmp_file.close
    @tmp_file.unlink
    @doc = nil
  end

  def test_file_must_be_present
    assert_nil @doc.file.filename, "attached file should be nil but was #{@doc.file}"
    assert_equal @doc.save, false, "should not save attched_document without file"
    @doc.file = @tmp_file
    assert @doc.save, "should save attached_document with file present"
  end

  def test_file_attributes_set_after_save
    assert_nil @doc.filename, "Filename should not be set yet"
    @doc.file = @tmp_file
    @doc.save
    assert_equal @doc.filename, @doc.file.identifier, "expected '#{@doc.file.identifier}' but got '#{@doc.filename}'"
  end
end
