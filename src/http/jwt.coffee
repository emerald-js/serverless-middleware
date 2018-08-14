
export default class JWT

	constructor: (@decoder) ->

	handle: (request, response, next) ->
		header = request.headers.Authorization
		if !header
			throw new Error 'Auth Header not Set'

		parts = header.split /\s+/
		if parts[0] isnt 'Bearer'
			throw new Error 'Authorisation Error'

		token = parts.pop()

		try
			token = @decoder token
		catch error
			throw new Error 'Authorisation Error'

		request.token = token

		await next()
