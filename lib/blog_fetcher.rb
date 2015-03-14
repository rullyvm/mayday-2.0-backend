class BlogFetcher
  BASE_URL = 'http://blog.mayday.us/api'
  ENDPOINTS = {
    recent:         '/read/json?num=5',
    press_releases: '/read/json?tagged=press%20release&num=5'
  }

  KEY_BASE = "blog_feeds"
  EXPIRE_SECONDS = 3.hours.to_i

  def self.feed(param)
    redis.get(key(param)) || fetch_feed!(param)
  end

  private

  def self.fetch_feed!(param)
    feed = RestClient.get(BASE_URL + ENDPOINTS[param])
    redis.set(key(param), feed)
    redis.expire(key(param), EXPIRE_SECONDS)
    feed
  end

  def self.key(param)
    KEY_BASE + ":#{param}"
  end

  def self.redis
    @@redis ||= Redis.current
  end
end