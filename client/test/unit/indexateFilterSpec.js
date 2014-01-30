describe('Indexate Filter', function() {
	var originalUsers = {"users":[{"lastname":"Goy","firstname":"Antonina","age":28,"email":"agoy@gmail.com","created_on":1391075990000,"last_edited":1391076400000,"active":false,"originalIndex":0},{"lastname":"Onufryk","firstname":"Roman","age":30,"email":"roman@onufryk.info","created_on":1391073970000,"last_edited":1391092220396,"active":true,"originalIndex":1},{"firstname":"Zed","lastname":"Dead","age":"35","email":"zedsdead@gmail.com","active":true,"created_on":1391087643842,"last_edited":1391087643842,"originalIndex":2}]};
  var expectedUsers = [ { lastname : 'Goy', firstname : 'Antonina', age : 28, email : 'agoy@gmail.com', created_on : 1391075990000, last_edited : 1391076400000, active : false, originalIndex : 0 }, { lastname : 'Onufryk', firstname : 'Roman', age : 30, email : 'roman@onufryk.info', created_on : 1391073970000, last_edited : 1391092220396, active : true, originalIndex : 1 }, { firstname : 'Zed', lastname : 'Dead', age : '35', email : 'zedsdead@gmail.com', active : true, created_on : 1391087643842, last_edited : 1391087643842, originalIndex : 2 } ];

	beforeEach(angular.mock.module('xuApp'));
	
	it('is defined', inject(function($filter){
		var filter = $filter('indexate');
		
		expect(filter).not.toBe(null);
		expect(filter).toBeDefined();
	}));

	it('adds original index to all users', inject(function($filter){
		var filter = $filter('indexate');
		
		var indexedUsers = filter(originalUsers.users);
		
		expect(JSON.stringify(indexedUsers)).toBe(JSON.stringify(expectedUsers));
	}));

});
