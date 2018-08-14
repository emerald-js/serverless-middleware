
export default class ErrorHandler

	handle: (request, response, next) ->
		try
			await next()
		catch error
			@handleError error, response


	handleError: (error, response) ->
		if error.viewable
			response.status = error.status
			response.json {
				code: error.code
				message: error.message
			}

		else
			throw error
