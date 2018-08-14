
export default class Validate

	constructor: (@joi, @aliases = {}, @rules = {}) ->

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


		return (request, response, next) =>
			data = {}

			for field in fields
				data[field] = if aliasFunc = @aliases[field]
					aliasFunc request
				else
					request[field]

			try
				request.data = await @joi.validate data, schema

			catch error
				if not error.isJoi
					throw error

				fields = []
				for detail in error.details
					fields.push {
						message: detail.message
						key: detail.context.key
					}

				response.status = 400
				response.json {
					code: 		'INPUT_VALIDATION_ERROR'
					message:	error.details[0].message
					fields
				}

				return


			await next()
