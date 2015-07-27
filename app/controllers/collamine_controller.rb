# Declaring a class method:
class CollamineController < ApplicationController

# Define method called index:
  def index

# Creating empty array:
    @pie_chart_data, @line_chart_data = [], []

# Everything that comes after the << is added to the array of @pie_chart_data
    @pie_chart_data << { 'label' => ' ', 'value' => Cache.where(source: 'original').count }
    @pie_chart_data << { 'label' => ' ', 'value' => Cache.where(source: 'collamine').count }
  end

# Define method called cm:
  def cm

# Creating empty array:
    @pie_chart_data, @line_chart_data = [], []

# Everything that comes after the << is added to the array of @pie_chart_data
    @pie_chart_data << { 'label' => ' ', 'value' => Cache.where(source: 'original').count }
    @pie_chart_data << { 'label' => ' ', 'value' => Cache.where(source: 'collamine').count }

# Everything that comes after the << is added to the array of @line_chart_data
    @line_chart_data << { label: "Original", values: [ {time: Time.now.to_i, y: 0}, {time: Time.now.to_i, y: 0} ] }
    @line_chart_data << { label: "Collamine", values: [ {time: Time.now.to_i, y: 0}, {time: Time.now.to_i, y: 0} ] }

# Counting the source field where it is from 'original'
    @uploads =  Cache.where(source: 'original').count 

# Counting the source field where it is from 'collamine'
    @downloads =  Cache.where(source: 'collamine').count 

# Counting the total documents in the database:
    @total = Cache.count

# Extracting the url field from the database and limiting to display only 10 records:
    @url = Cache.desc(:created_at).limit(10).pluck(:url)

# Extracting the DIFFERENT domain field from the database and limiting to display only 10 records:
    @domain = Cache.desc(:created_at).distinct(:domain).take(10)

# Finding usage statistics on my system using usagewatch gem
    usw = Usagewatch
    @disk = usw.uw_diskused
    @memory = usw.uw_memused
    @cpu = usw.uw_cpuused
    @reads = usw.uw_diskioreads
    @writes = usw.uw_diskiowrites

  end

# Define method called download:
  def download

# Taking from the query parameter that was passed in from the HTML after'?' (Query string parameters):
    url = params[:url]

# Get the filename unless last character is a /
    filename = url[-1,1] == '/' ? "" : url.split('/').last

# Set the url without the filename so that we can encode any special characters of the filename later
    url.slice!(filename)

# Querying the database for documents where the URL matches the url ^ and convert to array:
    document = Cache.where(url: url+CGI::escape(filename)).to_a

# Send binary data of content to be downloaded as HTML document:
    send_data(document.first.content, :filename => filename, :type => "text/html; charset=utf-8", :disposition => 'attachment')
  end

# Define method called line:
  def line

# Taking from the query parameter that was passed in from the HTML after'?' and converting it to integer:
    prev_total = params[:total].to_i

# Count the total documents in the database now:
    curr_total = Cache.count

# Calculating the difference in the number of documents after both counts:
    new_documents = curr_total - prev_total

# Setting both original and collamine data to 0    
    original, collamine = 0, 0

# If the difference of the both counts are 0, (which means no documents had been added within the time frame)
    if new_documents > 0

# Sort the documents in cache by date and convert to an array
      documents = Cache.desc(:created_at).limit(new_documents).to_a

# Loop through the array and see which ones are collamine / original
      documents.each do |document|
      original = original + 1 if document.source == "original"
      collamine = collamine + 1 if document.source == "collamine"
      end   
    end

# Returns the value of time as an integer:
    time = Time.now.to_i

# Render json data containing time for x axis, count for y axis for updating the line chart:
    render :json => [{time: time, y: original},{time: time, y: collamine}]
  end

# Defining a method called ajax:
  def ajax

# Render json data containing the different fields: (For ajax use)
    render :json => { total: Cache.count, 
                      uploads: Cache.where(source: 'original').count, 
                      downloads: Cache.where(source: 'collamine').count, 
                      urls: Cache.desc(:created_at).limit(10).pluck(:url), 
                      domains:  Cache.desc(:created_at).distinct(:domain).take(10)
                    }
  end

  def watch
    usw = Usagewatch
# Render json data containing the different fields: (For ajax use)
    render :json => { 
                      disk: usw.uw_diskused,
                      memory: usw.uw_memused,
                      cpu: usw.uw_cpuused,
                      reads: usw.uw_diskioreads,
                      writes: usw.uw_diskiowrites
                    }
  end
# Defining a method called pie:
  def pie

# Render json data containing the different fields: (For ajax use)
    render :json => [
      { label: ' ', value: Cache.where(source: 'original').count},
      { label: ' ', value: Cache.where(source: 'collamine').count} 
    ]
  end
end

