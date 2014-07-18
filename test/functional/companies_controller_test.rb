require File.expand_path('../../test_helper', __FILE__)

class CompaniesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test 'should export all companies' do
    get :index, format: :csv
    #assert_response :success
    assert_not_nil assigns(:companies), 'companies were not assigned (nil)'

    assert_equal response.header['Content-Type'], 'application/zip'
    assert_equal assigns(:companies).count, Company.all.count
  end
end
