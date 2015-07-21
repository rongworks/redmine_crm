angular.module('contacts').factory("CrmActionsService", function($resource) {
    return $resource("/crm_actions/:id.json", { id: "@id" },
        {
            'create':  { method: 'POST' },
            'index':   { method: 'GET', isArray: true },
            'show':    { method: 'GET', isArray: false },
            'update':  { method: 'PUT' },
            'destroy': { method: 'DELETE' }
        }
    );
});