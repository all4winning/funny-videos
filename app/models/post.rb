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
  scope :popular_videos, -> {select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             group('posts.id').
                             order('total DESC')}
  scope :trending_videos, -> {select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             where('post_views.updated_at >= ?', 1.week.ago).
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

  def next_video
    Post.where("id > ?", self.id).order("id asc").first
  end

  def previous_video
    Post.where("id < ?", self.id).order("id desc").first
  end
  
  def related_videos
    related_videos ||= Posts::Video.select('COUNT(*) AS total, posts.*').
                                  where('posts.id != ?', self.id).
                                  joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                                  joins(:categories).
                                  where("categories.id in (#{categories.pluck(:id).join(',')})").
                                  group('posts.id').
                                  order('total DESC, created_at DESC').published  
  end
  
  def like(user_id)
    rep = Reputation.find_by_user_id_and_post_id(user_id, id)
    if Reputation.exists?(rep)
      if rep.like == 0
        rep.like = 1
        rep.unlike = 0
        rep.save()
      end
    else
      Reputation.create(user_id: user_id, post_id: id, like: 1, unlike: 0)  
    end
  end
  
  def unlike(user_id)
    rep = Reputation.find_by_user_id_and_post_id(user_id, id)
    if Reputation.exists?(rep)
      if rep.unlike == 0
        rep.like = 0
        rep.unlike = 1
        rep.save()
      end
    else
      Reputation.create(user_id: user_id, post_id: id, like: 0, unlike: 1)  
    end
  end
end
