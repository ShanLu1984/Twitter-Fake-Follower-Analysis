%% compute statistics that we need for analysis

function [A] = degree_percentage(A, f_th, t_th, fa_th)

A.size = length(A.nFollowed);

follower = A.nFollowed;
tweets = A.nTweets;
favorite = A.nFavorite;

A.median_follower = median(A.nFollowed);
A.median_tweets = median(A.nTweets);
A.median_following = median(A.nFollowing);
A.median_favorite = median(A.nFavorite);

A.url_percentage = sum(A.hasUrl) / A.size;
A.defautImage_percentage = 1 - sum(A.hasImage) / A.size;

temp_follower = follower - f_th;
temp_tweets = tweets - t_th;
temp_favorite = favorite - fa_th;

A.follower_percentage = sum(any(temp_follower < 0,1)) / A.size;
A.tweets_percentage = sum(any(temp_tweets < 0,1)) / A.size;
A.favorite_percentage = sum(any(temp_favorite < 0,1)) / A.size;

end

