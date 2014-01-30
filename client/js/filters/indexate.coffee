angular.module('xuApp')
	.filter 'indexate', -> (arr) ->
		resarr = []
		for item, index in arr
			item.originalIndex = index
			resarr.push item
		resarr
