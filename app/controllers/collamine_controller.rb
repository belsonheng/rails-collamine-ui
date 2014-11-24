class CollamineController < ApplicationController
  def index
  	@pie_chart_data, @line_chart_data = [], []
  	
  	@pie_chart_data << { 'label' => 'Original', 'value' => Cache.where(source: 'original').count }
  	@pie_chart_data << { 'label' => 'Collamine', 'value' => Cache.where(source: 'collamine').count }
  end
end
