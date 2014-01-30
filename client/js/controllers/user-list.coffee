window.app.controller 'UserListCtrl', ['$scope', '$route', '$filter', '$window', 'User', 'indexateFilter', ($scope, $route, $filter, $window, User, indexateFilter) ->
	$scope.currentPage = 0
	$scope.perPage = 10
	$scope.numberOfPages = 0
	
	$scope.isAddRowShown = false
	$scope.orderType = 'email'
	$scope.filterQuery = null
	
	$scope.editingRow = null
	$scope.editingUser = {}
	
	$scope.newUser =
		active: false

	displayUsers = ->
		return unless $scope.users
		sortedUsers = angular.copy($scope.users).sort((a,b) ->
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

	loadUsers = ->
		User.query (data) ->
			$scope.users = indexateFilter data.users
			displayUsers()

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
	
	getIndexByEmail = (email) ->
		for user in $scope.users
			return user.originalIndex if user['email'] == email
		-1 # not found
	
	$scope.addUser = ->
		if not $scope.newUser.email || not $scope.newUser.firstname || not $scope.newUser.lastname
			#TODO: display error nicely
			alert('Please fill required fields')
			return
		if getIndexByEmail($scope.newUser.email) >= 0
			#TODO: display error nicely
			alert('Email ' + $scope.newUser.email + ' is already taken')
			return
		newUser = 
			firstname: $scope.newUser.firstname
			lastname: $scope.newUser.lastname
			age: $scope.newUser.age
			email: $scope.newUser.email
			active: $scope.newUser.active
			created_on: (new Date()).getTime()
			last_edited: (new Date()).getTime()
		$scope.users.push newUser
		$scope.isAddRowShown = false
		User.store {users: $scope.users}, -> loadUsers()

	$scope.updateUser = ->
		if not $scope.editingUser.email || not $scope.editingUser.firstname || not $scope.editingUser.lastname
			#TODO: display error nicely
			alert('Please fill required fields')
			return
		if getIndexByEmail($scope.editingUser.email) >= 0 && getIndexByEmail($scope.editingUser.email) != $scope.editingUser.originalIndex
			#TODO: display error nicely
			alert('Email ' + $scope.editingUser.email + ' is already taken')
			return
		$scope.editingUser.last_edited = (new Date()).getTime()
		$scope.users[$scope.editingUser.originalIndex] = $scope.editingUser
		User.store {users: $scope.users}, -> loadUsers()
		$scope.cancelEdit()

	$scope.edit = (index) ->
		$scope.editingRow = index
		$scope.editingUser = angular.copy($scope.displayedUsers[index])

	$scope.cancelEdit = () ->
		$scope.editingRow = null
		$scope.editingUser = null
		
	$scope.destroy = (email) ->
		if confirm('Sure?')
			updatedUsers = []
			for user in $scope.users
				updatedUsers.push user unless user['email'] == email
			$scope.users = updatedUsers
			User.store {users: $scope.users}, -> loadUsers()

	$scope.$watch 'usersForm.$dirty', (isDirty) ->
		if isDirty
			$window.onbeforeunload = () ->
				'You haven\'t save your changes';
	
	loadUsers()
]
