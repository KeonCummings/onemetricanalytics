class FacebookInsight < ActiveRecord::Base
  def self.get_pages(user_token)
    user_metrics = Koala::Facebook::API.new(user_token)
    pages = user_metrics.get_connections('me', 'accounts')
    pages
  end

  def self.get_page_token(user_token)
  	user_metrics = Koala::Facebook::API.new(user_token)
  	pages = user_metrics.get_connections('me', 'accounts')
    page_tokens = pages.first['access_token']
  end

  def self.page_insights(page_token,metric,start_date,end_date)
    @page_graph = Koala::Facebook::API.new(page_token)
    #get page insights data
    @page_graph.get_connections('me', "insights/#{metric}", since: start_date, until: end_date)
    #get page feed data
    # @page_graph.get_connections('me', 'feed')
    #get page post data
    # @page_graph.get_connections('365182493518892', 'insights', since:'2014-01-01', until: '2014-01-31')
  end

  def self.post_insights(page_token, metric, start_date, end_date)
     @post_graph = Koala::Facebook::API.new(page_token)
     @post_graph = @post_graph.get_connections('me', 'feed')
     post_id = @post_graph.first['id']
     @post_graph.get_connections(post_id, metric, since: start_date, until: end_date)
  end

  def self.get_values(data_object)
  	date_value = Hash.new
  	data_object.first.values[3].each do |insight|
  		formatDate = DateTime.parse(insight['end_time'])
  		formatDate = formatDate.strftime('%F')
      begin
  		  date_value[formatDate] = insight['value']
      rescue
        date_value[formatDate] = 0
      end
  	end
  	date_value
  end

  def self.create_value_array(hash)
  	value_array = Array.new
  	hash.each {|k,v| value_array.push(v)}
  	value_array
  end

  def self.create_date_array(hash)
    date_array = Array.new
    hash.each {|k,v| date_array.push(k)}
    date_array
  end

  def self.mean(array)
	array.inject(0) { |sum, x| sum += x }.to_f / array.size.to_i
  end

  def self.performance_score(page_token,metric,start_date,end_date)
  	score = mean(create_value_array(get_values(page_insights(page_token,metric,start_date,end_date))))
  end

  def self.content_score(average)
  	score = 27 * Math.log(average) + 50
    if score == Float::INFINITY
      score = 120
    elsif score == -Float::INFINITY
      score = -120
    elsif score == Float::NAN
      score = 0
    end
  	score.to_i
  end

  def self.combine_hash(hash1, hash2)
    results = Hash.new
    hash1.each {|k,v| results[k] = [v]}
    hash2.each {|k,v| results[k].push(v)}
    results
  end

  def self.get_engagement_rates(combined_hash)
    engagement_rates = Hash.new
    combined_hash.each do |k,v| 
      erPercent = v[0]/v[1].to_f * 100
      erPercent = erPercent.round(2)
      # engagement_rates[k] = "#{erPercent}%"
    end
    engagement_rates
  end
end


  def engagement_rate_score(pageToken, metric1, metric2, daysStart, daysEnd)
    #set page token for grabbing data
    token = pageToken
    #set the time frame and get the data for the comparison data
    q1Start = DateTime.now
    q1Start = q1Start.strftime('%F')
    q1End = DateTime.now - daysStart
    q1End = q1End.strftime('%F')
    q1DataM1 = FacebookInsight.page_insights(token, metric1, q1End, q1Start)
    q1DataM2 = FacebookInsight.page_insights(token, metric2, q1End, q1Start)
    # q1_data_hash_m1 = FacebookInsight.get_values(q1DataM1)
    # q1_data_hash_m2 = FacebookInsight.get_values(q1DataM2)
    # combinedMain = FacebookInsight.combine_hash(q1_data_hash_m1, q1_data_hash_m2)
    # mainHash = FacebookInsight.get_engagement_rates(combinedMain)
    # q1_data_array = FacebookInsight.create_value_array(mainHash)
    # q1_data_mean = FacebookInsight.mean(q1_data_array)
    # q2Start = DateTime.now - daysEnd
    # q2Start = q2Start.strftime('%F')
    # q2End = DateTime.now - daysStart
    # q2End = q2End.strftime('%F')
    # q2DataM1 = FacebookInsight.page_insights(token, metric1, q2Start, q2End)
    # q2DataM2 = FacebookInsight.page_insights(token, metric2, q2Start, q2End)
    # q2_data_hash_m1 = FacebookInsight.get_values(q2DataM1)
    # q2_data_hash_m2 = FacebookInsight.get_values(q2DataM2)
    # combinedMain2 = FacebookInsight.combine_hash(q2_data_hash_m1, q2_data_hash_m2)
    # mainHash2 = FacebookInsight.get_engagement_rates(combinedMain2)
    # q2Array = FacebookInsight.create_value_array(mainHash2)
    # q2_data_mean = FacebookInsight.mean(q2Array)
    # qoqComparison = q1_data_mean/q2_data_mean
    # data_score = FacebookInsight.content_score(qoqComparison)
  end
  
u = UserAuthentication.where(user_id: 1).first.token
m = Koala::Facebook::API.new(u)
m = m.get_connections('me', 'accounts')
m = m.first['access_token']
@pageData = FacebookInsight.page_insights(m, "page_posts_impressions", "2015-07-01", "2015-07-28")
@pageData2 = FacebookInsight.page_insights(m, "page_engaged_users", "2015-07-01", "2015-07-28")
@engagements = FacebookInsight.get_values(@pageData2)
@impressions = FacebookInsight.get_values(@pageData)
@allData = FacebookInsight.combine_hash(@engagements, @impressions)
@er = FacebookInsight.get_engagement_rates(@allData)

# @page_graph = Koala::Facebook::API.new(m)
# @feed = @post_graph.get_connection('me', 'feed')
# @postid = @feed.first['id']
# @x = @post_graph.get_connections(@postid, 'likes', since: "2015-05-17", until: "2015-07-17")
# def my_loop()
#   @comments = 0
#   @count = 0
#   @comments += @x.length
#   while @x.next_page != nil
#      @comments += @x.length
#      @count += 1
#      @x = @x.next_page
#   end
# end

# def getPostIds(feed)
#   @pids = Array.new
#   feed.each {|f| @pids.push(f['id'])}
#   while feed.next_page != nil
#     feed = feed.next_page
#     feed.each {|f| @pids.push(f['id'])}
#   end
# end





