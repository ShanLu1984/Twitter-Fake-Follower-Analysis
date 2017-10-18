%% sampling latimes

%% prepare for the data to collect
clc;
clear;
close all;

credentials.ConsumerKey = 'bkwLn6eUv37TKwHGQaEQyoPrA';
credentials.ConsumerSecret = '6FSnzHpZBCtcxECtngljesgGLSd1auKo5fkJK5bXDEqlD6KldX';
credentials.AccessToken = '43661868-MAvq8uzynspVJkXVVKgKPazTowkrzbSwv3zSbh1eA';
credentials.AccessTokenSecret = 'wGPD0rvIKHdbjWoLMA9VRcGO5CmlWQxiXN4WuN40KEAhd';

tw = twitty(credentials);

pause(15 * 60);

id_name = 'Arab_News';
loadname = strcat(id_name,'.mat');
savename = strcat(id_name,'_samples.mat');

load(loadname);
total_size = size(total_f_ids,2);

sampling_size = round(0.1 * total_size);
sampling_turn = ceil(sampling_size / 100);

nFollowed = zeros(1,sampling_size);
nFollowing = zeros(1,sampling_size);
hasUrl = zeros(1,sampling_size);
nFavorite = zeros(1,sampling_size);
nTweet = zeros(1,sampling_size);
hasImage = zeros(1,sampling_size);

dayCreated = zeros(1,sampling_size);
yearCreated = zeros(1,sampling_size);
monthCreated = zeros(1,sampling_size);


sampling_num = randperm(total_size,sampling_size);

s0 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_0_normal.png');
s1 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_1_normal.png');
s2 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_2_normal.png');
s3 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_3_normal.png');
s4 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png');
s5 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_5_normal.png');
s6 = fliplr('abs.twimg.com/sticky/default_profile_images/default_profile_6_normal.png');

%% collect the data with twitter api
for i = 1:sampling_turn
    
    start_num = (i - 1) * 100 + 1;
    if start_num + 99 <= sampling_size
        end_num = start_num + 99;
    else
        end_num = sampling_size;
    end
    fetch_id = sampling_num(start_num:end_num);
    temp = num2cell(total_f_ids(fetch_id));
    % twitty_obj.usersLookup(twtr,varargin): return up to 100 users worth
    % of extended information.
    temp_json = tw.usersLookup('user_id', temp);
    lookup_samples = loadjson(temp_json);
    clc;
    display(i);
    adding_size = size(lookup_samples,2);
    
    for j = 1:adding_size
        nFollowed(start_num + j - 1) = lookup_samples{1,j}.followers_count;
        nFollowing(start_num + j - 1) = lookup_samples{1,j}.friends_count;
        nFavorite(start_num + j - 1) = lookup_samples{1,j}.favourites_count;
        nTweet(start_num + j - 1) = lookup_samples{1,j}.statuses_count;
        
        if isempty(lookup_samples{1,j}.url) == 0
            hasUrl(start_num + j - 1) = 1;
        end
        
        image_url = fliplr(lookup_samples{1,j}.profile_image_url);
        
        if strncmp(image_url,s0,72) + strncmp(image_url,s1,72) + strncmp(image_url,s2,72) + strncmp(image_url,s3,72) ...
                + strncmp(image_url,s4,72) + strncmp(image_url,s5,72) + strncmp(image_url,s6,72) ~= 1
            hasImage(start_num + j - 1) = 1;
        end
        
        create_time = lookup_samples{1,j}.created_at;
        format_time = strcat(create_time(5:11),create_time(26:30));
        formatIn = 'mmm dd yyyy';
        num_time = datevec(format_time,formatIn);
        dayCreated(start_num + j - 1) = num_time(3);
        yearCreated(start_num + j - 1) = num_time(1);
        monthCreated(start_num + j - 1) = num_time(2);
            
    end
    
    if i / 60 == round(i / 60)
        pause(15 * 60);
    end
end

%% save the data
save(savename,'nFollowed','nFollowing','nFavorite','nTweet',...
    'hasUrl','hasImage','dayCreated','yearCreated','monthCreated');

