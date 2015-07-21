contacts.controller("CrmActionsController",['CrmActionsService',function(crm_actions_service){
    var vm = this;

    function init() {
        vm.crmActions = crm_actions_service.query();
        vm.selectedActions = [];
        vm.selectedAction = null;
    }

    vm.setSelected = function(action) {
        var index = vm.selectedActions.indexOf(action);
        if(index < 0){
            vm.selectedActions.push(action);
        }
        else{
            vm.selectedActions.splice(action,1);
        }
    };
    init();
}]);