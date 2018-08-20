
export default class Knex

	constructor: (@knex, @config) ->

	handle: (ctx, next) ->
		db = new @knex @config

		ctx.db = db

		try
			await next()
		catch error
			db.destroy()
			throw error

		db.destroy()
