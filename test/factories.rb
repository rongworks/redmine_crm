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

end