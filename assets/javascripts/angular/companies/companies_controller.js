contacts.controller("CompaniesController",['CompaniesService',function(companies_service){
    var vm = this;

    function init() {
        vm.companies = companies_service.query();
        vm.crm_actions = [{id:1,name:'Test1'}, {id:2,name:'Test2'}];
        vm.ascending = true;
        vm.selectedCompanies = [];
        vm.showActionModal = false;
    }

    vm.setSelected = function(company, overwrite) {
        if(overwrite){
            vm.selectedCompanies.length = 0;
            //vm.resetSelection(); // TODO: should be called by view..
        }
        var index = vm.selectedCompanies.indexOf(company);
        if(index < 0){
            vm.selectedCompanies.push(company);
        }
        else{
            vm.selectedCompanies.splice(index,1);
        }
    };

    vm.toggleSelectionAll = function(companies){
        if (vm.selectedCompanies.length > 0){
            vm.selectedCompanies.length = 0;
        }
        else{
            Array.prototype.push.apply(vm.selectedCompanies, companies);
        }
    };

    vm.resetSelection = function(){
      angular.element("#company_list").find("input[checkbox]").attr("checked",false);
    };

    vm.addActions = function(actions){
        for (var i=0; i < vm.selectedCompanies.length;i++){
            var company = vm.selectedCompanies[i];
            console.log(company);
            for(var j=0; j < actions.length;j++) {
                var action = actions[j];
                if (company.crm_actions == null || typeof(company.crm_actions) == 'undefined'){
                    company.crm_actions = [];
                }
                var index = company.crm_actions.indexOf(action);
                if (index < 0) {
                    company.crm_actions.push(action);
                }
            }
            company.$update();
        }
    };


    init();
}]);