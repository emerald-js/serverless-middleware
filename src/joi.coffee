
export default class Joi

	constructor: (@joi, @rules = {}) ->

	handle: (fields) ->
		if Array.isArray fields
			schema = {}
			for field in fields
				if rule = @rules[field]
					schema[field] = rule
				else
					throw new Error "No validation rule found for field: #{field}"

		else if fields instanceof Object
			schema = fields

		else
			throw new TypeError 'Argument fields must be an object or array'

		return (ctx, next) =>
			ctx.input = await @joi.validate ctx.input, schema

			await next()
