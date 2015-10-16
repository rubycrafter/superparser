class Statistics
  attr_reader :total_items, :items_in_group, :items_without_picture

  def initialize
    @total_items = 0.0
    @items_in_group = {}
    @items_wothout_picture = 0.0
  end
end
