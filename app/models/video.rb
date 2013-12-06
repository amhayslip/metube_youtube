class Video < ActiveRecord::Base
  belongs_to :user
  has_many :ratings
  validates :user_id, :youtube_id, presence: true

  after_create :youtube_query

  def youtube_query
    response = Unirest.get("https://www.googleapis.com/youtube/v3/videos?part=snippet%2C+statistics&id=#{self.youtube_id}&key=#{ENV['YOUTUBE_API_KEY']}")
    self.title = response.body["items"][0]["snippet"]["title"]
    self.description = response.body["items"][0]["snippet"]["description"]
    self.save
  end


  def avg_rating
    total = 0.0
    self.ratings.to_a.each do |rating|
      total += rating.value
    end
    if self.ratings.count == 0
      return 0
    else
      return total / self.ratings.count
    end
  end



end