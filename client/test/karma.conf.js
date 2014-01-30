module.exports = function(config) {
	config.set({
		// base path, that will be used to resolve files and exclude
		basePath : '../..',

		frameworks : ['jasmine'],

		// list of files / patterns to load in the browser
		files : [
			'client/vendor/js/angular/angular.js',
			'client/vendor/js/angular/angular-route.js',
			'client/vendor/js/angular/angular-resource.js',
			'client/vendor/js/angular/angular-mocks.js',
			'client/vendor/js/underscore.js',
			'public/js/*.js',
			'client/test/unit/*.js'
		],
		
		preprocessors: {
			'**/*.coffee' : ['coffee']
		},
		
		coffeePreprocessor: {
			options: {
				bare: true,
				sourceMap: false
			},
			transformPath: function(path) {
				return path.replace(/\.js$/, '.coffee');
			}
		},

		reporters : ['progress'],

		port : 9876,

		colors : true,

		logLevel : config.LOG_INFO,
		
		loggers: [
			{
				type: 'console'
			}, 
			{
				type: "file", 
				filename:"./log/karma.log", 
				"maxLogSize": 10000000,
				"backups": 0
			}
		],

		autoWatch : true,

		browsers : ['Firefox'],

		captureTimeout : 20000,

		singleRun : true,

		reportSlowerThan : 500,

		plugins : [
			'karma-jasmine', 
			'karma-chrome-launcher', 
			'karma-firefox-launcher', 
			'karma-junit-reporter', 
			'karma-commonjs'
		]
	});
}; 
