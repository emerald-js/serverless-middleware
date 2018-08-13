
import NormalSSM  from '../ssm'

export default class SSM extends NormalSSM

	handle: (request, response, next) ->
		await super.handle null, next
