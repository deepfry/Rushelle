axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
contentful   = require 'roots-contentful'
slugify      = require 'slugify'

module.exports =
	ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

	extensions: [
		js_pipeline(files: ['assets/js/*.coffee', 'assets/**/*.js']),
		css_pipeline(files: ['assets/css/*.styl', 'assets/**/*.css'])
	
		contentful
			access_token: '18bdb58bd1616ff2e763894051a8d6a932f6dc7872379f1af13f11d4bd06cc52'
			space_id: '6ennsccihdpb'
			content_types:
				##Variable_name:
					##id: 'ID' ##FIND THIS ON CONTENTFUL
					##template: 'views/partial/_cf_post.jade' ##render out content based on this template
					##filters: { 'fields.environment[in]': ['staging', 'production'] } ##filter for language, etc
					##path: (e) -> "blogging/#{e.category}/#{slugify(e.title)}" ##custom path
					##write: 'data.json' ##write a JSON file with the data
				categories:
					id: 'category'
					filters:{
						'order':''
					}
				homeslider:
					id: 'sliderImage'
				featured:
					id: 'galleryImage'
					filters:{
						'order':'fields.date'
						'fields.featured' : 'true'
					}
					path: (e) -> "gallery/#{slugify(e.title)}"
					template: 'views/partials/_gallery-item.jade'
				gallery:
					id: 'galleryImage'
					filters:{
						'order':'fields.date'
						#'fields.category.fields.categoryName' : 'Featured'
					}
					path: (e) -> "gallery/#{slugify(e.title)}"
					template: 'views/partials/_gallery-item.jade'

	]

	stylus:
		use: [axis(), rupture(), autoprefixer()]
		sourcemap: true

	'coffee-script':
		sourcemap: true

	jade:
		pretty: true
	server:
		clean_urls:true
