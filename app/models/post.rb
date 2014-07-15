class Post < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_many :post_views
  has_many :reputations
  has_many :favorites, class_name: "::Favorite"
  belongs_to :user, counter_cache: true

  attr_readonly :post_views_count

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]
  
  scope :published, -> {where(state: 'published')}
  scope :pending, -> {where(state: 'pending')}
  scope :featured, -> {where(featured: 'True')}
  scope :top_posts, -> {select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN reputations ON posts.id = reputations.post_id').
                             where('reputations.updated_at >= ?', 1.day.ago).
                             group('posts.id').
                             order('total DESC')}
  
  state_machine initial: :pending do
    state :pending, value: 'pending'
    state :published, value: 'published'
    state :rejected, value: 'rejected'
    
    event :publish do
      transition :pending => :published
    end

    event :reject do
      transition [:pending, :published] => :rejected
    end
  end

  def favorized_by?(user)
    favorites.where(user_id: user.id).count > 0
  end
  
  def reputation
    rep = Reputation.select("SUM(reputations.like) as likes, SUM(unlike) as unlikes").
                             group('post_id').
                             where('post_id =?',id)
    if rep.exists?
      reputation=rep[0].likes - rep[0].unlikes
    else
      reputation=0
    end 
    reputation                                                  
  end
    
  def favorites_count
    favorites.count
    
  end  
end
