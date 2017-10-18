% Produce full followers' list

%% prepare for the data to collect
clc;
close all;
clear;

credentials.ConsumerKey = 'bkwLn6eUv37TKwHGQaEQyoPrA';
credentials.ConsumerSecret = '6FSnzHpZBCtcxECtngljesgGLSd1auKo5fkJK5bXDEqlD6KldX';
credentials.AccessToken = '43661868-MAvq8uzynspVJkXVVKgKPazTowkrzbSwv3zSbh1eA';
credentials.AccessTokenSecret = 'wGPD0rvIKHdbjWoLMA9VRcGO5CmlWQxiXN4WuN40KEAhd';

tw = twitty(credentials);

screen_name = 'PutinRF_Eng';
temp_json = tw.usersShow('screen_name', screen_name);
user_status = loadjson(temp_json);

user_fo_count = user_status.followers_count;

display(user_fo_count);

num_fetch = ceil(user_fo_count / 5000);

pause(15 * 60);

start_num = 1;
current_cursor = '-1';

%% collect the data with twitter api
for i = 1:num_fetch
    display(i);
    tic;
    
    % twitty_obj.followersIds(twtr,varargin): Returns an array of numeric IDs for every user following the specified user.
    temp_json = tw.followersIds('screen_name', screen_name,'cursor',current_cursor);
    
    followers_ids = loadjson(temp_json);
    current_cursor = followers_ids.next_cursor_str;
    size_f_ids = size(followers_ids.ids,2);
    end_num = start_num + size_f_ids - 1;
    
    f_ids = followers_ids.ids;
    total_f_ids(1,start_num:end_num) = f_ids;
    start_num = end_num + 1;
    
    if i / 15 == round(i / 15)
        % wait 15 minutes
        pause(15 * 60);
    end
    toc;
end

%% save the data
savename = strcat(screen_name,'.mat');
save(savename,'total_f_ids');
