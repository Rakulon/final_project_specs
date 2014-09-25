class SitesController < ApplicationController
	include AlchemyHelper
  def sindex
  end


  def post
  	apikey = "3ac44bf7795811504bef8447a9b3fc10e12262ae"
    source = params[:source]
    handle = params[:handle]
   

 	source_map = {
 		"twitter" => "http://twitter.com/",
 		"facebook" => "http://www.facebook.com/", 
 		"linkedin" => "http://linkedin.com/in/"}
	
	url = source_map[source] + handle

    
	@sentiment = AlchemyHelper.overall_sentiment(url)
	@entities = AlchemyHelper.entities(url)
	logger.info("entities #{@entities}")


	@positive_score = 0
	@negative_score = 0
	@neutral_score = 0
	@type_scores = {"City" => 0, "Person" => 0, "Country" => 0, "Crime" => 0, "Company" => 0, "Organization" => 0, "FieldTerminology" => 0, "Technology" => 0, "OperatingSystem" => 0, "TwitterHandle" => 0}
	
	@copy = @entities.map do |entity|
		entity_type = entity["type"]
		entity_sentiment = entity["sentiment"]["type"]
		if entity_sentiment == "positive" then @positive_score+=1 end
		if entity_sentiment == "negative" then @negative_score+=1 end
		if entity_sentiment == "neutral" then @neutral_score+=1 end
		#entity_relevance = entity["relevance"]
		#entity_score = entity["score"]

		if @type_scores[entity_type] then
		@type_scores[entity_type] += 1
		end
		entity_text = entity["text"]
		
		text(handle, entity_type, entity_sentiment, entity_text)
	end
	@number_copy = @copy.select { |score| score != nil  }
	@filtered_copy = @copy.select { |x| x != nil }
	@handle = handle

# types: company / crime / person / city / country /

  end

  def text(handle, type, sentiment, t)
  	text_map = {
		"City" => {
			"positive" => "#{handle} really wants to live in #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} would never live in #{t}, in fact he can't stand those people"
		},
		"Person" => {
			"positive" => "#{handle} is a fan of #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} hates #{t}"
		},
		"Country" => {
			"positive" => "#{handle} is patriotic about #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} honestly dislikes #{t}"
		},
		"Crime" => {
			"positive" => "#{handle} somehow likes #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is not ok with #{t}"
		},
		"Company" => {
			"positive" => "#{handle} would enjoy working more with #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is negative in general about #{t}"
		},
		"Organization" => {
			"positive" => "#{handle} supports #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is against #{t}"
		},
		"FieldTerminology" => {
			"positive" => "#{handle} supports #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is against #{t}"
		},
		"Technology"   => {
			"positive" => "#{handle} uses #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is against use of #{t}"
		},
		"OperatingSystem" => {
			"positive" => "#{handle} uses #{t}",
			"neutral"  => "#{handle} is neutral about #{t}, despite many mentions",
			"negative" => "#{handle} is against use of #{t}"
		},
		"TwitterHandle" => {
			"positive" => "#{handle} retweets #{t}",
			"neutral"  => "#{handle} reads many of #{t}'s tweets",
			"negative" => "#{handle} dislikes #{t}"
		},
	}
	if text_map[type] then
		text_map[type][sentiment]
	else
		nil
	end
  end
end




