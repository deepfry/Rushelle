axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
contentful   = require 'roots-contentful'
slugify      = require 'slugify'

records      = require 'roots-records'
collections  = require 'roots-collections'
excerpt      = require 'html-excerpt'
moment       = require 'moment'

monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

module.exports =
	ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

	locals:
		postExcerpt: (html, length, ellipsis) ->
			excerpt.text(html, length || 100, ellipsis || '...')
		dateFormat: (date, format) ->
			moment(date).format(format)
		basedir:'views'

	extensions: [
		js_pipeline(files: ['assets/js/*.coffee', 'assets/**/*.js']),
		css_pipeline(files: ['assets/css/*.styl', 'assets/**/*.css']),
		records(
				characters: { file: "data/characters.json" }
				site: { file: "data/site.json" }
			),
		collections(
			folder: 'posts', 
			layout: 'partials/post',
			prepare:(post) ->
				post.slug = '/test/'+slugify(post.title)
			),
		contentful
			access_token: '66391e41d08566abbc5f99bc5dda732d5461ab80523b2dd666c17c87eab57842'
			space_id: 'yet7mgppcdzv'
			content_types:
				##Variable_name:
					##id: 'ID' ##FIND THIS ON CONTENTFUL
					##template: 'views/partial/_cf_post.jade' ##render out content based on this template
					##filters: { 'fields.environment[in]': ['staging', 'production'] } ##filter for language, etc
					##path: (e) -> "blogging/#{e.category}/#{slugify(e.title)}" ##custom path
					##write: 'data.json' ##write a JSON file with the data
				categories:
					id: 'category'
				homeslider:
					id: 'sliderImage'
				about:
					id: 'aboutPage'
				featured:
					id: 'galleryImage'
					filters:{
						'order':'-fields.date'
						'fields.featured' : 'true'
					}
					path: (e) -> "gallery/#{slugify(e.title)}"
					template: 'views/partials/_gallery-item.jade'
				gallery:
					id: 'galleryImage'
					filters:{
						'order':'-fields.date'
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
