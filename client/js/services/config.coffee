angular.module('xuConfig',[]).provider 'config',
	options: {}
	set: (options) ->
		angular.extend @options, options
	$get: ->
		res = new Object()
		res.options = @options
		res
