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
