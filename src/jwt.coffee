
export default class JWT

	constructor: (@decoder) ->

	handle: (ctx, next) ->
		try
			token = @decoder ctx.input.token
		catch error
			throw new Error 'Authorisation Error'

		ctx.token = token

		await next()
