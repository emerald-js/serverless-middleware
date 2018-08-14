
export default class Joi

	constructor: (@Joi, @rules = {}) ->

	handle: (fields) ->
		if typeof fields is 'object'
			schema = fields

		else if typeof fields is 'array'
			schema = {}
			for field in fields
				if rule = @rules[field]
					schema[field] = rule
				else
					throw new Error "No validation rule found for field: #{field}"

		else
			throw new TypeError 'Argument fields must be an object or array'

		return (ctx, next) =>
			ctx.input = await @Joi.validate ctx.input, schema

			await next()
