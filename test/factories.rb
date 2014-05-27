# This will guess the User class
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
    company valid_company

  end

  # This will use the User class (Admin would have been guessed)
  factory :company, class: Company do
    name "Test Firma"
    branch "Testing"
    extra_information "Zusatzinformation"
    mail "test@example.com"
    organisation 1
    province "Provinz 1"
    state "Testland"
    street "Teststraße 1"
    url "http://www.test-firma.de"
    zip_code "123456"
  end
end