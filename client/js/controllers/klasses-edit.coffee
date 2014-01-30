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
