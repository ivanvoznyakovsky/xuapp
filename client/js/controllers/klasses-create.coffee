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
