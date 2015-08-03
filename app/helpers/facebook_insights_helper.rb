module FacebookInsightsHelper
	  def score(pageToken, metric, daysStart, daysEnd)
		token = pageToken
		q1Start = DateTime.now
		q1Start = q1Start.strftime('%F')
		q1End = DateTime.now - daysStart
		q1End = q1End.strftime('%F')
		q1Data = FacebookInsight.page_insights(token, metric, q1End, q1Start)
		q1_data_hash = FacebookInsight.get_values(q1Data)
		q1_data_array = FacebookInsight.create_value_array(q1_data_hash)
		q1_data_mean = FacebookInsight.mean(q1_data_array)
		q2Start = DateTime.now - daysEnd
		q2Start = q2Start.strftime('%F')
		q2End = DateTime.now - daysStart
		q2End = q2End.strftime('%F')
		q2Data = FacebookInsight.page_insights(token, metric, q2Start, q2End)
		q2Hash = FacebookInsight.get_values(q2Data)
		q2Array = FacebookInsight.create_value_array(q2Hash)
		q2_data_mean = FacebookInsight.mean(q2Array)
		qoqComparison = q1_data_mean/q2_data_mean
		@data_score = FacebookInsight.content_score(qoqComparison)
	end

	def engagement_rate_score(pageToken, metric1, metric2, daysStart, daysEnd)
	    ##set page token for grabbing data
	    token = pageToken
	    #set the time frame and get the data for the comparison data
	    q1Start = DateTime.now
	    q1Start = q1Start.strftime('%F')
	    q1End = DateTime.now - daysStart
	    q1End = q1End.strftime('%F')
	    q1DataM1 = FacebookInsight.page_insights(token, metric1, q1End, q1Start)
	    q1DataM2 = FacebookInsight.page_insights(token, metric2, q1End, q1Start)
	    q1_data_hash_m1 = FacebookInsight.get_values(q1DataM1)
	    q1_data_hash_m2 = FacebookInsight.get_values(q1DataM2)
	    combinedMain = FacebookInsight.combine_hash(q1_data_hash_m1, q1_data_hash_m2)
	    mainHash = FacebookInsight.get_engagement_rates(combinedMain)
	    @q1_data_array = FacebookInsight.create_value_array(mainHash)
	    @q1_data_array = FacebookInsight.remove_from_array(@q1_data_array)
	    @q1_data_mean = FacebookInsight.mean(@q1_data_array)
	    q2Start = DateTime.now - daysEnd
	    q2Start = q2Start.strftime('%F')
	    q2End = DateTime.now - daysStart
	    q2End = q2End.strftime('%F')
	    q2DataM1 = FacebookInsight.page_insights(token, metric1, q2Start, q2End)
	    q2DataM2 = FacebookInsight.page_insights(token, metric2, q2Start, q2End)
	    q2_data_hash_m1 = FacebookInsight.get_values(q2DataM1)
	    q2_data_hash_m2 = FacebookInsight.get_values(q2DataM2)
	    combinedMain2 = FacebookInsight.combine_hash(q2_data_hash_m1, q2_data_hash_m2)
	    mainHash2 = FacebookInsight.get_engagement_rates(combinedMain2)
	    @q2Array = FacebookInsight.create_value_array(mainHash2)
	    @q2Array = FacebookInsight.remove_from_array(@q2Array)
	    @q2_data_mean = FacebookInsight.mean(@q2Array)
	    qoqComparison = @q1_data_mean/@q2_data_mean
	    data_score = FacebookInsight.content_score(qoqComparison)
	end

	def metrics_history(pageToken, metric, daysStart)
		token = pageToken
		q1Start = DateTime.now
		q1Start = q1Start.strftime('%F')
		q1End = DateTime.now - daysStart
		q1End = q1End.strftime('%F')
		q1Data = FacebookInsight.page_insights(token, metric, q1End, q1Start)
		q1_data_hash = FacebookInsight.get_values(q1Data)
		# q1_data_array = FacebookInsight.create_value_array(q1_data_hash)
	end

	def metrics_history_eur(pageToken, metric1, metric2, daysStart)
		token = pageToken
		q1Start = DateTime.now
		q1Start = q1Start.strftime('%F')
		q1End = DateTime.now - daysStart
		q1End = q1End.strftime('%F')
		q1Data = FacebookInsight.page_insights(token, metric1, q1End, q1Start)
		q1Data2 = FacebookInsight.page_insights(token, metric2, q1End, q1Start)
		q1_data_hash = FacebookInsight.get_values(q1Data)
		q1_data_hash2 = FacebookInsight.get_values(q1Data2)
		allData = FacebookInsight.combine_hash(q1_data_hash, q1_data_hash2)
		er = FacebookInsight.get_engagement_rates(allData)
		# q1_data_array = FacebookInsight.create_value_array(q1_data_hash)
	end

	def combine_hash(hash1, hash2)
	    results = Hash.new
	    hash1.each {|k,v| results[k] = [v]}
	    hash2.each {|k,v| results[k].push(v)}
	    results
	end

	def date_array(pageToken, metric, daysStart)
		token = pageToken
		q1Start = DateTime.now
		q1Start = q1Start.strftime('%F')
		q1End = DateTime.now - daysStart
		q1End = q1End.strftime('%F')
		q1Data = FacebookInsight.page_insights(token, metric, q1End, q1Start)
		q1_data_hash = FacebookInsight.get_values(q1Data)
		q1_date_array = FacebookInsight.create_date_array(q1_data_hash)
	end

	def fb_pages(userToken)
		@pages = FacebookInsight.get_pages(userToken)
		@pages
	end
end

