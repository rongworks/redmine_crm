contacts = angular.module('contacts',['ngResource']);

// dskj
// work with csrf protection
contacts.config(function($httpProvider) {
    var authToken;
    authToken = $("meta[name=\"csrf-token\"]").attr("content");
    return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});

// turbolinks workaround
$(document).on('page:load', function() {
    return $('[ng-app]').each(function() {
        var module;
        module = $(this).attr('ng-app');
        return angular.bootstrap(this, [module]);
    });
});
