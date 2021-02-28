if Rails.env.test? || Rails.env.development?
  $redis = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 14)
else
  $redis = Redis.new(:host => '127.0.0.1', password: "lijia20210223", :port => 6543, :db => 14)
end