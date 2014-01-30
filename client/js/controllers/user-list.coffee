window.app.controller 'UserListCtrl', ['$scope', '$route', '$filter', '$window', 'User', 'indexateFilter', ($scope, $route, $filter, $window, User, indexateFilter) ->
	# paging 
	$scope.currentPage = 0
	$scope.perPage = 10
	$scope.numberOfPages = 0
	
	# sorting and filtering
	$scope.orderType = 'email'
	$scope.filterQuery = null
	
	# helper field for currently editing user (one at any moment)
	$scope.editingRow = null
	$scope.editingUser = {}

	# should the new user row be displayed	
	$scope.isAddRowShown = false
	# default value for a new user
	$scope.newUser =
		active: false

	# performs sorting, filtering and paging of the users array, the original array is not affected
	displayUsers = ->
		return unless $scope.users
		
		# Sorting here has the extended conditions, so we can adjust sorting for different column types in future
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
		
		# Filtering on all fields, normalized to lowercase, for dates - using the date format
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


		# Slicing the filtered and sorted results to show only one page
		$scope.numberOfPages = if filteredUsers.length % $scope.perPage == 0 then (filteredUsers.length / $scope.perPage - 1) else (Math.floor(filteredUsers.length / $scope.perPage)) 
		firstIndex = $scope.currentPage * $scope.perPage
		lastIndex = firstIndex + $scope.perPage
		$scope.firstIndex = firstIndex + 1
		$scope.lastIndex = if lastIndex > filteredUsers.length then filteredUsers.length else lastIndex
		
		$scope.displayedUsersTotal = filteredUsers.length
		
		$scope.displayedUsers = filteredUsers.slice firstIndex, lastIndex

	# Loads the list of users from the server, replaces the current state
	loadUsers = ->
		User.query (data) ->
			$scope.users = indexateFilter data.users
			displayUsers()

	# Go to previous page, I don't have check for page existance, because there's a check in the view - it wouldn't show a button if it's not available
	$scope.previousPage = ->
		$scope.currentPage--
		displayUsers()

	# Go to next page, I don't have check for page existance, because there's a check in the view - it wouldn't show a button if it's not available
	$scope.nextPage = ->
		$scope.currentPage++
		displayUsers()

	# Sets the order field and direction, if field name is the same as before - changes direction, otherwise - field name
	$scope.setOrder = (fieldName) ->
		if $scope.orderType == fieldName
			$scope.orderType = ('-' + fieldName)
		else 
			if $scope.orderType == ('-' + fieldName)
				$scope.orderType = (fieldName)
			else 
				$scope.orderType = fieldName
		displayUsers()

	# Here we watch for the changes of the query field, and filter the records accordingly, paging is regenerated in this case
	$scope.$watch 'query', (newValue, oldValue) ->
		if newValue == '' 
			$scope.filterQuery = null
		else  
			$scope.filterQuery = newValue
		displayUsers()
	
	# Helper method used to check is the email address unique, and to get the original index in the users database if not unique
	getIndexByEmail = (email) ->
		for user in $scope.users
			return user.originalIndex if user['email'] == email
		-1 # not found
	
	# Stores a new user in memory and persists it to the server API
	$scope.addUser = ->
		if not $scope.newUser.email || not $scope.newUser.firstname || not $scope.newUser.lastname
			#TODO: display errors nicely
			alert('Please fill required fields')
			return
		if getIndexByEmail($scope.newUser.email) >= 0
			#TODO: display errors nicely
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

	# Updates existing user in memory and persists it to the server API
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

	# Toggle inline edit mode on. Use deep copy of edited item, to preserve original content.
	$scope.edit = (index) ->
		$scope.editingRow = index
		$scope.editingUser = angular.copy($scope.displayedUsers[index])

	# Toggle inline mode off, reset state of the form.
	$scope.cancelEdit = () ->
		$scope.editingRow = null
		$scope.editingUser = null
		# No changes - reset form to pristine state
		$scope.usersForm.$setPristine()
	
	# Deletes existing user in memory and persists it to the server API
	$scope.destroy = (email) ->
		if confirm('Sure?')
			updatedUsers = []
			for user in $scope.users
				updatedUsers.push user unless user['email'] == email
			$scope.users = updatedUsers
			User.store {users: $scope.users}, -> loadUsers()

	# Tricky hook for catching the dirty state of the form
	$scope.$watch 'usersForm.$dirty', (isDirty) ->
		if isDirty
			$window.onbeforeunload = () ->
				'You haven\'t save your changes'
		else
			$window.onbeforeunload = null
	
	loadUsers()
]
