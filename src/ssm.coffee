
export default class SSM

	done: false
	processing: false

	constructor: (@config, @ssm) ->

	handle: (ctx, next) ->
		if @done
			await next()
			return

		if @processing
			await @promise
			await next()
			return

		@processing = true
		@promise = @fetch()
		await @promise
		@done = true

		await next()

	fetch: ->
		paths = @parseSSM @config
		names = paths.map (i) -> i.path

		if !names.length
			return

		params = {
			Names: names
			WithDecryption: true
		}

		try
			result = await @ssm.getParameters(params).promise()
		catch error
			throw error

		if result.InvalidParameters and result.InvalidParameters.length
			throw new Error "SSM parameter(s) not found - ['ssm:#{result.InvalidParameters.join("', 'ssm:")}']"

		values = @parseValues result.Parameters

		for item in paths
			item.ref[item.key] = values[item.path]


	parseValues: (params) ->
		values = {}

		for item in params
			if item.Type is 'StringList'
				values[item.Name] = item.Value.split ','
			else
				values[item.Name] = item.Value

		return values


	parseSSM: (object, level = 0) ->
		list = []

		for key, value of object
			switch typeof value
				when 'string'
					if value.substr(0, 4) is 'ssm:'
						list.push {
							ref: object
							path: value.substr 4
							key
						}
				when 'object'
					if level <= 3
						list = list.concat @parseSSM value, level + 1

		return list
