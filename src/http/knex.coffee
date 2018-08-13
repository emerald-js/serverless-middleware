
export default class Knex

	constructor: (@knex, @config) ->

	handle: (request, response, next) ->
		db = new @knex @config

		request.db = db

		try
			await next()
		catch error
			db.destroy()
			throw error

		db.destroy()
