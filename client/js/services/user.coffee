angular.module('xuServices').factory 'User', ['$resource', 'config', ($resource, config) ->
	$resource(
		config.options.apiUrl + ':script' + '.php' # add "?fake=yes" for random data mode
		{}
		{
			query:
				method: 'GET'
				params:
					script: 'list'
			store:
				method: 'POST'
				params:
					script: 'store'
		}
	)
]
