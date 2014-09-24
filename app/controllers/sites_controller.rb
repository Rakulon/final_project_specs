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
 		"instagram" => "http://instagram.com/"}
	
	url = source_map[source] + handle

    
	@sentiment = AlchemyHelper.overall_sentiment(url)
	@entities = AlchemyHelper.entities(url)
	logger.info("entities #{@entities}")

	@copy = @entities.map do |entity|
		entity_type = entity["type"]
		entity_sentiment = entity["sentiment"]["type"]
		entity_text = entity["text"]
		
		text(handle, entity_type, entity_sentiment, entity_text)
	end

	@filtered_copy = @copy.select { |x| x != nil }
	@handle = handle

# types: company / crime / person / city / country /

  end

  def text(handle, type, sentiment, t)
  	text_map = {
		"City" => {
			"positive" => "#{handle} really wants to live in #{t}!",
			"negative" => "#{handle} would never live in #{t}, in fact he can't stand those people."
		},
		"Person" => {
			"positive" => "#{handle} really is a fan of #{t}!",
			"negative" => "#{handle} hates #{t}."
		},
		"Country" => {
			"positive" => "#{handle} is patriotic about #{t}!",
			"negative" => "#{handle} honestly dislikes #{t}."
		},
		"Crime" => {
			"positive" => "#{handle} somehow likes #{t}!",
			"negative" => "#{handle} is not ok with #{t}."
		}
	}
	if text_map[type] then
		text_map[type][sentiment]
	else
		nil
	end
  end
end
