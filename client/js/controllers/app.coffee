window.app.controller 'AppCtrl', ['$scope', ($scope) ->
	$scope.errors = {}
		
	$scope.updateErrorHandler = (errorResponse) ->
		return unless errorResponse?.data?.errors?
		for error in errorResponse.data.errors
			$scope.errors[error.field] = [] unless $scope.errors[error.field]
			$scope.errors[error.field].push error.message
		true
]
