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

	updateUsers = ->
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

	$scope.destroy = (email) ->
		if confirm('Sure?')
			updatedUsers = []
			for user in $scope.users
				updatedUsers.push user unless user['email'] == email
			$scope.users = updatedUsers
			User.store {users: $scope.users}, -> updateUsers()
	
	updateUsers()
]
