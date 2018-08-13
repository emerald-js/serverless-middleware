export default class Knex

	constructor: (@Knex, @config) ->

	handle: (ctx, next) ->
		db = new @Knex @config

		ctx.db = db

		try
			await next()
		catch error
			db.destroy()
			throw error

		db.destroy()
