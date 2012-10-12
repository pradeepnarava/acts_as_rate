class Rating < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
  has_many :user_ratings

  delegate :max_rating, :to => :rateable

  def rate(score, user, user_is_pro)
    #user_ratings.find_or_initialize_by_user_id(user.id).update_attributes!(:score => score)
		if user_is_pro
    	user_ratings.find_or_initialize_by_user_id(user.id).update_attributes!(:score => score,:is_pro => true)
		else
    	user_ratings.find_or_initialize_by_user_id(user.id).update_attributes!(:score => score)
		end
    reload
  end

  # Call this method the update the avarage rating; you don't normally need to
  # do this manually, saving or updating a user rating already takes care of
  # updating the avarage rating.
  def update_rating
    self.average_rating = user_ratings.average(:score,:conditions => ['is_pro IS NULL OR is_pro = 0'])
    #self.average_rating = user_ratings.average(:score)
    self.average_rating_pro = user_ratings.average(:score,:conditions => ['is_pro = ?', 1])
    #self.ratings_count = user_ratings.count(:conditions => ['is_pro !=  1'])
    self.ratings_count = user_ratings.count(:conditions => ['is_pro IS NULL OR is_pro = 0'])
    self.ratings_count_pro = user_ratings.count(:conditions => ['is_pro = ?', 1])
    save!
  end

end
