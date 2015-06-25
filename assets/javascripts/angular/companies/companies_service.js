angular.module('contacts').factory("CompaniesService", function($resource) {
    return $resource("/companies/:id.json", { id: "@id" },
        {
            'create':  { method: 'POST' },
            'index':   { method: 'GET', isArray: true },
            'show':    { method: 'GET', isArray: false },
            'update':  { method: 'PUT' },
            'destroy': { method: 'DELETE' }
        }
    );
});