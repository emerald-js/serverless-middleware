export default class ErrorHandler

	handle: (request, response, next) ->
		try
			await next()
		catch error
			@handleError error, response


	handleError: (error, response) ->
		if error.isJoi
			fields = []
			for detail in error.details
				fields.push {
					message: detail.message
					key: detail.context.key
				}

			response.status = 400
			response.json {
				code: 'INPUT_VALIDATION_ERROR'
				message: error.details[0].message
				fields
			}

		else if error.viewable
			response.status = error.status
			response.json {
				code: error.code
				message: error.message
			}

		else
			throw error
