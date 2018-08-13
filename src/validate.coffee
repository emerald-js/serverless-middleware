export default class Validate

	constructor: (@Joi, @aliases, @rules) ->

	handle: (fields) ->
		return (request, response, next) =>
			data 	= {}
			schema 	= {}

			for field in fields
				data[field] = if aliasFunc = @aliases[field]
					aliasFunc request
				else
					request[field]

				if rule = @rules[field]
					schema[field] = rule
				else
					throw new Error "No validation rule found for field: #{field}"

			request.data = await @Joi.validate data, schema

			await next()
