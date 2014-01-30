angular.module('xuServices', ['ngResource']);

window.app = angular.module('xuApp', ['ngRoute', 'xuServices', 'xuConfig'])
.config ['$routeProvider', '$httpProvider', '$locationProvider', 'configProvider', ($routeProvider, $httpProvider, $locationProvider, configProvider) ->
	$locationProvider.hashPrefix '!'
	#locationProvider.html5Mode(true)

	$routeProvider
		.when '/', 
			templateUrl: 'partials/app/user/list.html'
			controller: 'UserListCtrl'

		.when '/users',
			templateUrl: 'partials/app/user/list.html'
			controller: 'UserListCtrl'

		.otherwise redirectTo: '/'
]
