(function() {
  angular.module('xuServices', ['ngResource']);

  window.app = angular.module('xuApp', ['ngRoute', 'xuServices', 'xuConfig']).config([
    '$routeProvider', '$httpProvider', '$locationProvider', 'configProvider', function($routeProvider, $httpProvider, $locationProvider, configProvider) {
      $locationProvider.hashPrefix('!');
      return $routeProvider.when('/', {
        templateUrl: 'partials/app/user/list.html',
        controller: 'UserListCtrl'
      }).when('/users', {
        templateUrl: 'partials/app/user/list.html',
        controller: 'UserListCtrl'
      }).otherwise({
        redirectTo: '/'
      });
    }
  ]);


  /*
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
   */

  window.app.controller('AppCtrl', [
    '$scope', function($scope) {
      $scope.errors = {};
      return $scope.updateErrorHandler = function(errorResponse) {
        var error, _i, _len, _ref, _ref1;
        if ((errorResponse != null ? (_ref = errorResponse.data) != null ? _ref.errors : void 0 : void 0) == null) {
          return;
        }
        _ref1 = errorResponse.data.errors;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          error = _ref1[_i];
          if (!$scope.errors[error.field]) {
            $scope.errors[error.field] = [];
          }
          $scope.errors[error.field].push(error.message);
        }
        return true;
      };
    }
  ]);

  window.app.controller('KlassesCreateCtrl', [
    '$scope', '$location', 'Subcategory', 'Klass', 'plainlistFilter', function($scope, $location, Subcategory, Klass, plainlistFilter) {
      $scope.klass = {
        name: ''
      };
      Subcategory.query(function(subcategories_list) {
        return $scope.subcategories = plainlistFilter(subcategories_list.subcategories);
      });
      return $scope.save = function() {
        return Klass.save({
          klass: $scope.klass
        }, function(data) {
          return $location.path('/classes');
        }, $scope.updateErrorHandler);
      };
    }
  ]);

  window.app.controller('KlassesEditCtrl', [
    '$scope', '$routeParams', '$location', 'Subcategory', 'Klass', 'plainlistFilter', function($scope, $routeParams, $location, Subcategory, Klass, plainlistFilter) {
      Klass.get({
        klassId: $routeParams.klassId
      }, function(data) {
        $scope.klass = new Klass(data.klass);
        return $scope.klass.subcategory_id = $scope.klass.subcategory_id.toString();
      });
      Subcategory.query(function(subcategories_list) {
        return $scope.subcategories = plainlistFilter(subcategories_list.subcategories);
      });
      return $scope.save = function() {
        return $scope.klass.$update({
          klassId: $scope.klass.id
        }, function(data) {
          return $location.path('/classes');
        }, $scope.updateErrorHandler);
      };
    }
  ]);

  window.app.controller('KlassesViewCtrl', [
    '$scope', '$routeParams', 'Subcategory', 'Klass', 'plainlistFilter', function($scope, $routeParams, Subcategory, Klass, plainlistFilter) {
      Subcategory.query(function(subcategories_list) {
        return $scope.subcategories = plainlistFilter(subcategories_list.subcategories);
      });
      return Klass.get({
        klassId: $routeParams.klassId
      }, function(data) {
        return $scope.klass = data.klass;
      });
    }
  ]);

  window.app.controller('UserListCtrl', [
    '$scope', '$route', '$filter', 'User', function($scope, $route, $filter, User) {
      var displayUsers;
      $scope.currentPage = 0;
      $scope.perPage = 10;
      $scope.numberOfPages = 0;
      $scope.isAddRowShown = false;
      $scope.orderType = 'email';
      $scope.filterQuery = null;
      displayUsers = function() {
        var filteredUsers, firstIndex, lastIndex, sortedUsers, user, _i, _len;
        if (!$scope.users) {
          return;
        }
        sortedUsers = $scope.users.sort(function(a, b) {
          var result, sortDirection, sortField;
          if ($scope.orderType.indexOf('-') === 0) {
            sortField = $scope.orderType.substr(1);
            sortDirection = -1;
          } else {
            sortField = $scope.orderType;
            sortDirection = 1;
          }
          if (a[sortField] < b[sortField]) {
            result = -1;
          } else if (a[sortField] > b[sortField]) {
            result = 1;
          } else {
            result = 0;
          }
          return result * sortDirection;
        });
        if ($scope.filterQuery) {
          $scope.filterQuery = $scope.filterQuery.toLowerCase();
          filteredUsers = [];
          for (_i = 0, _len = sortedUsers.length; _i < _len; _i++) {
            user = sortedUsers[_i];
            if (user['firstname'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['lastname'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['email'].toLowerCase().indexOf($scope.filterQuery) >= 0 || user['age'].toString().indexOf($scope.filterQuery) >= 0) {
              filteredUsers.push(user);
            } else if ($filter('date')(user['created_on'], 'MM/dd/yyyy hh:mm:ss a').toLowerCase().indexOf($scope.filterQuery) >= 0 || $filter('date')(user['last_edited'], 'MM/dd/yyyy hh:mm:ss a').toLowerCase().indexOf($scope.filterQuery) >= 0) {
              filteredUsers.push(user);
            }
          }
        } else {
          filteredUsers = sortedUsers;
        }
        $scope.numberOfPages = filteredUsers.length % $scope.perPage === 0 ? filteredUsers.length / $scope.perPage - 1 : Math.floor(filteredUsers.length / $scope.perPage);
        firstIndex = $scope.currentPage * $scope.perPage;
        lastIndex = firstIndex + $scope.perPage;
        $scope.firstIndex = firstIndex + 1;
        $scope.lastIndex = lastIndex > filteredUsers.length ? filteredUsers.length : lastIndex;
        $scope.displayedUsersTotal = filteredUsers.length;
        return $scope.displayedUsers = filteredUsers.slice(firstIndex, lastIndex);
      };
      User.query(function(data) {
        $scope.users = data.users;
        return displayUsers();
      });
      $scope.showAddUserRow = function() {
        return $scope.isAddRowShown = true;
      };
      $scope.hideAddUserRow = function() {
        return $scope.isAddRowShown = false;
      };
      $scope.previousPage = function() {
        $scope.currentPage--;
        return displayUsers();
      };
      $scope.nextPage = function() {
        $scope.currentPage++;
        return displayUsers();
      };
      $scope.setOrder = function(fieldName) {
        if ($scope.orderType === fieldName) {
          $scope.orderType = '-' + fieldName;
        } else {
          if ($scope.orderType === ('-' + fieldName)) {
            $scope.orderType = fieldName;
          } else {
            $scope.orderType = fieldName;
          }
        }
        return displayUsers();
      };
      $scope.$watch('query', function(newValue, oldValue) {
        if (newValue === '') {
          $scope.filterQuery = null;
        } else {
          $scope.filterQuery = newValue;
        }
        return displayUsers();
      });
      return $scope.destroy = function(userId) {
        if (confirm('Sure?')) {
          return (new User()).$remove({
            userId: userId
          }, function() {
            return $route.reload();
          });
        }
      };
    }
  ]);

  angular.module('xuConfig', []).provider('config', {
    options: {},
    set: function(options) {
      return angular.extend(this.options, options);
    },
    $get: function() {
      var res;
      res = new Object();
      res.options = this.options;
      return res;
    }
  });

  angular.module('xuServices').factory('User', [
    '$resource', 'config', function($resource, config) {
      return $resource(config.options.apiUrl + ':script' + '.php', {}, {
        query: {
          method: 'GET',
          params: {
            script: 'list'
          }
        }
      });
    }
  ]);

}).call(this);

//# sourceMappingURL=../../public/js/app.js.map
