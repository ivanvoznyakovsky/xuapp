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
###
		.when '/accounts',
			templateUrl: 'partials/app/account/list.html'
			controller: 'AccountsCtrl'
		.when '/accounts/:accountId/view',
			templateUrl: 'partials/app/account/view.html'
			controller: 'AccountsViewCtrl'
		.when '/accounts/:accountId/edit',
			templateUrl: 'partials/app/account/edit.html'
			controller: 'AccountsEditCtrl'
		.when '/accounts/new',
			templateUrl: 'partials/app/account/new.html'
			controller: 'AccountsCreateCtrl'

		.when '/subcategories',
			templateUrl: 'partials/app/subcategory/list.html'
			controller: 'SubcategoriesCtrl'
		.when '/subcategories/:subcategoryId/view',
			templateUrl: 'partials/app/subcategory/view.html'
			controller: 'SubcategoriesViewCtrl'
		.when '/subcategories/:subcategoryId/edit',
			templateUrl: 'partials/app/subcategory/edit.html'
			controller: 'SubcategoriesEditCtrl'
		.when '/subcategories/new',
			templateUrl: 'partials/app/subcategory/new.html'
			controller: 'SubcategoriesCreateCtrl'

		.when '/classes',
			templateUrl: 'partials/app/klass/list.html'
			controller: 'KlassesCtrl'
		.when '/classes/:klassId/view',
			templateUrl: 'partials/app/klass/view.html'
			controller: 'KlassesViewCtrl'
		.when '/classes/:klassId/edit',
			templateUrl: 'partials/app/klass/edit.html'
			controller: 'KlassesEditCtrl'
		.when '/classes/new',
			templateUrl: 'partials/app/klass/new.html'
			controller: 'KlassesCreateCtrl'

		.when '/taxonomy',
			templateUrl: 'partials/app/taxonomy/tree.html'
			controller: 'TaxonomyTreeCtrl'
###
