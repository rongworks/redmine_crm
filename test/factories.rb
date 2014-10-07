# This will guess the class
FactoryGirl.define do

  factory :contact, class: Client do
    department "Tester"
    email "tester1@example.com"
    fax "123456"
    first_name "Max"
    last_name "Power"
    phone "1234567"
    salutation "Herr"
    salutation_letter "Sehr geehrter Herr"
    title "Dr.Prof."
    association :company, factory: :company

  end

  # This will use the class
  factory :company, class: Company do
    name "Test Firma"
    branch "Testing"
    extra_information "Zusatzinformation"
    mail "test@example.com"
    organisation 1
    province "Provinz 1"
    state "Testland"
    street "Teststrasse 1"
    url "http://www.test-firma.de"
    zip_code "123456"
  end

  factory :comment, class: Crmcomment do
    user {User.create}
    dtime   {Time.now}
    comment "Ein Kommentar"
    association :commentable, factory: :contact
  end

  factory :admin, class: User do
    status 1
    last_login_on '2006-07-19 22:57:52 +02:00'
    language 'en'
    # password = admin
    salt '82090c953c4a0000a7db253b0691a6b4'
    hashed_password 'b5b6ff9543bf1387374cdfa27a54c96d236a7150'
    admin true
    mail 'admin@somenet.foo'
    lastname 'Admin'
    firstname 'Redmine'
    id 1
    mail_notification 'all'
    login 'admin'
    type 'User'
  end
  factory :project, class: Project do
    name 'test project'
    id 1
    description 'Some description'
    homepage 'http://ecookbook.somenet.foo/'
    is_public true
    identifier 'testproject'
  end

  factory :crm_action, class: CrmAction do
    name 'test action'
    id 1
    description 'a test action'
    start_date '2006-07-19'
    end_date '2006-08-19'
  end

  factory :attached_document, class: AttachedDocument do
    association :user, factory: :admin
    association :container, factory: :company
    locked false
    file {fixture_file_upload('files/test_doc.txt', 'text/plain')}
  end
end