module AlchemyHelper
	@base = "http://access.alchemyapi.com/calls/url"
	@apikey = funkey	
	module_function
	def overall_sentiment(url)
		texts_url = "#{@base}/URLGetTextSentiment?url=#{url}&apikey=#{@apikey}&outputMode=json"
		request = Typhoeus.get(texts_url)
    	return JSON.parse(request.body)["docSentiment"]["type"]
	end


	def entities(url)
		entities_url = "#{@base}/URLGetRankedNamedEntities?url=#{url}&apikey=#{@apikey}&outputMode=json&sentiment=1"
		request = Typhoeus.get(entities_url)
    	return JSON.parse(request.body)["entities"]
	end



end
