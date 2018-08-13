
export default class Validate

	constructor: (@joi, @aliases = {}, @rules = {}) ->

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
			throw new TypeError ""


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
