window.app.controller 'KlassesViewCtrl', ['$scope', '$routeParams', 'Subcategory', 'Klass', 'plainlistFilter', ($scope, $routeParams, Subcategory, Klass, plainlistFilter) ->
	Subcategory.query (subcategories_list) ->
		$scope.subcategories = plainlistFilter subcategories_list.subcategories
	Klass.get klassId: $routeParams.klassId, (data) -> $scope.klass = data.klass
]
