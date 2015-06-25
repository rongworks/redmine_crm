contacts.controller("CompaniesController",['CompaniesService',function(companies_service){
    var vm = this;

    function init() {
        vm.companies = companies_service.query();
        vm.attributes = ['kundennr','firma','plz'];
        vm.orderAttribute = 'kundennr';
        vm.ascending = true;
    }

    init();
}]);