export default class Cors

	constructor:(@origins = ['*']) ->

	handle: (request, response, next) ->
		response.set 'Access-Control-Allow-Origin', @origins.join ','
		await next()
