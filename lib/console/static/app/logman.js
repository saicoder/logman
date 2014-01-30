var logman = angular.module('logman',['ngRoute','ngResource','ui.bootstrap']);

logman.config(['$routeProvider','$locationProvider', function($routeProvider,$locationProvider) {
  $routeProvider.

  when('/', { templateUrl: '/app/dashboard-view'}). 
  
  when('/buckets/new', { templateUrl: '/app/bucket/add_edit.html'}). 
  when('/buckets/:id/details', { templateUrl: '/app/bucket/add_edit.html'}).
  
  when('/users', {templateUrl: '/app/user/list.html'}).
  
  when('/buckets/:id/logs', { templateUrl: '/app/bucket/logs.html'}).
  
  when('/api_guide', { templateUrl: '/app/api_guide/index.html'}).
  
  otherwise({ redirectTo: '/' });
  // configure html5 to get links working on jsfiddle
  // $locationProvider.html5Mode(true);
}]);


function LocationCtl($scope){
	angular.extend($scope, window.location);
}
