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

window.app.controller 'AppCtrl', ['$scope', ($scope) ->
	$scope.errors = {}
		
	$scope.updateErrorHandler = (errorResponse) ->
		return unless errorResponse?.data?.errors?
		for error in errorResponse.data.errors
			$scope.errors[error.field] = [] unless $scope.errors[error.field]
			$scope.errors[error.field].push error.message
		true
]

window.app.controller 'KlassesCreateCtrl', ['$scope', '$location', 'Subcategory', 'Klass', 'plainlistFilter', ($scope, $location, Subcategory, Klass, plainlistFilter) ->
	$scope.klass =
		name: ''
	Subcategory.query (subcategories_list) ->
		$scope.subcategories = plainlistFilter subcategories_list.subcategories
	$scope.save = ->
		Klass.save
			klass: $scope.klass
			(data) ->
				$location.path('/classes')
			$scope.updateErrorHandler
]

window.app.controller 'KlassesEditCtrl', ['$scope', '$routeParams', '$location', 'Subcategory', 'Klass', 'plainlistFilter', ($scope, $routeParams, $location, Subcategory, Klass, plainlistFilter) ->
  Klass.get
    klassId: $routeParams.klassId
    (data) -> 
      $scope.klass = new Klass data.klass
      # transform to fit angular ng-options logic
      $scope.klass.subcategory_id = $scope.klass.subcategory_id.toString()
  Subcategory.query (subcategories_list) ->
    $scope.subcategories = plainlistFilter subcategories_list.subcategories
  $scope.save = ->
    $scope.klass.$update
      klassId: $scope.klass.id
      (data) ->
        $location.path('/classes')
      $scope.updateErrorHandler
]

window.app.controller 'KlassesViewCtrl', ['$scope', '$routeParams', 'Subcategory', 'Klass', 'plainlistFilter', ($scope, $routeParams, Subcategory, Klass, plainlistFilter) ->
	Subcategory.query (subcategories_list) ->
		$scope.subcategories = plainlistFilter subcategories_list.subcategories
	Klass.get klassId: $routeParams.klassId, (data) -> $scope.klass = data.klass
]

window.app.controller 'UserListCtrl', ['$scope', '$route', '$filter', 'User', ($scope, $route, $filter, User) ->
	$scope.currentPage = 0
	$scope.perPage = 10
	$scope.numberOfPages = 0
	
	$scope.isAddRowShown = false
	$scope.orderType = 'email'
	$scope.filterQuery = null

	displayUsers = ->
		return unless $scope.users
		sortedUsers = $scope.users.sort((a,b) ->
			if $scope.orderType.indexOf('-') == 0 
				sortField = $scope.orderType.substr(1)
				sortDirection = -1
			else 
				sortField = $scope.orderType
				sortDirection = 1
		
		
			if a[sortField] < b[sortField]
				result = -1
			else if a[sortField] > b[sortField]
				result = 1
			else 
				result = 0

			result * sortDirection
		)
		#
		if $scope.filterQuery
			$scope.filterQuery = $scope.filterQuery.toLowerCase()
			filteredUsers = []
			for user in sortedUsers
				if user['firstname'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['lastname'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['email'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['age'].toString().indexOf($scope.filterQuery) >= 0
					filteredUsers.push user
				else if $filter('date')(user['created_on'], 'MM/dd/yyyy hh:mm:ss a').toLowerCase().indexOf($scope.filterQuery) >= 0 || $filter('date')(user['last_edited'], 'MM/dd/yyyy hh:mm:ss a').toLowerCase().indexOf($scope.filterQuery) >= 0
					filteredUsers.push user
		else 
			filteredUsers = sortedUsers


		$scope.numberOfPages = if filteredUsers.length % $scope.perPage == 0 then (filteredUsers.length / $scope.perPage - 1) else (Math.floor(filteredUsers.length / $scope.perPage)) 
		firstIndex = $scope.currentPage * $scope.perPage
		lastIndex = firstIndex + $scope.perPage
		$scope.firstIndex = firstIndex + 1
		$scope.lastIndex = if lastIndex > filteredUsers.length then filteredUsers.length else lastIndex
		
		$scope.displayedUsersTotal = filteredUsers.length
		
		$scope.displayedUsers = filteredUsers.slice firstIndex, lastIndex


	User.query (data) ->
		$scope.users = data.users
		displayUsers()

	$scope.showAddUserRow = ->
		$scope.isAddRowShown = true

	$scope.hideAddUserRow = ->
		$scope.isAddRowShown = false

	$scope.previousPage = ->
		$scope.currentPage--
		displayUsers()

	$scope.nextPage = ->
		$scope.currentPage++
		displayUsers()

	$scope.setOrder = (fieldName) ->
		if $scope.orderType == fieldName
			$scope.orderType = ('-' + fieldName)
		else 
			if $scope.orderType == ('-' + fieldName)
				$scope.orderType = (fieldName)
			else 
				$scope.orderType = fieldName
		displayUsers()

	$scope.$watch 'query', (newValue, oldValue) ->
		if newValue == '' 
			$scope.filterQuery = null
		else  
			$scope.filterQuery = newValue
		displayUsers()

	$scope.destroy = (userId) ->
		if confirm('Sure?')
			(new User()).$remove userId : userId, -> $route.reload()
]

angular.module('xuConfig',[]).provider 'config',
	options: {}
	set: (options) ->
		angular.extend @options, options
	$get: ->
		res = new Object()
		res.options = @options
		res

angular.module('xuServices').factory 'User', ['$resource', 'config', ($resource, config) ->
	$resource(
		config.options.apiUrl + ':script' + '.php'
		{}
		{
			query:
				method: 'GET'
				params:
					script: 'list'
		}
	)
]
