%% Analyze and visualize the sampling results

%% prepare for the data to analyze
clc;
clear;
close all;

type = 13;
follower_th = 5;
tweets_th = 5;
favorite_th = 1 ;

id{10}.name = 'PeoplesDaily_sample.mat';            
id{13}.name = 'XinhuaNews_samples.mat';                     
id{7}.name = 'GlobalTimes_samples.mat';                    
id{11}.name = 'USAToday_samples.mat';                       
id{9}.name = 'latimes_samples.mat';                
id{1}.name = 'AgenceFrance_samples.mat';                   
id{6}.name = 'ForeignPolicy_samples.mat';                  
id{5}.name = 'FinancialTimes_samples.mat';                 
id{2}.name = 'Arab_News_samples.mat';              
id{3}.name = 'BangkokPostNews_samples.mat';       
id{4}.name = 'DailyNewsEgypt_samples.mat';        
id{8}.name = 'HDNER_samples.mat';                 
id{12}.name = 'PutinRF_Eng_samples.mat';           

id{10}.color = [1 0 0];
id{13}.color = [0.8 0 0.8];
id{7}.color = [0.6 0.2 0];
id{11}.color = [0.302 0.745 0.933];
id{9}.color = [0 0 0];
id{1}.color = [0 0.447 0.741];
id{6}.color = [1 0.384 0.655];
id{5}.color = [0.929 0.694 0.125];
id{2}.color = [0 0.498 0];
id{3}.color = [0 1 0];
id{4}.color = [1 0.843 0];
id{8}.color = [0 0 1];
id{12}.color = [0.6 0.6 0.6];

id{10}.marker = 'o';
id{13}.marker = 'o';
id{7}.marker = 'o';
id{11}.marker = 'o';
id{9}.marker = 'o';
id{1}.marker = 'o';
id{6}.marker = 'o';
id{5}.marker = 'o';
id{2}.marker = 'o';
id{3}.marker = 'o';
id{4}.marker = 'o';
id{8}.marker = 'o';
id{12}.marker = 'o';

id{10}.size = 799000;  
id{13}.size = 2330000; 
id{7}.size = 397000; 
id{11}.size = 1720000; 
id{9}.size = 1540000; 
id{1}.size = 424000;
id{6}.size = 683000;
id{5}.size = 1930000;
id{2}.size = 55871;   
id{3}.size = 70465;   
id{4}.size = 186887;
id{8}.size = 128482;  
id{12}.size = 269189;

% id{i}.size is resized, it determine the marker's size
for i = 1:type
   id{i}.size = sqrt(round(id{i}.size / 100000)) * 5; 
end

%% collect the statistics of the data
result_median = zeros(4,type);
result_percentage = zeros(4,type);

for i = 1:type
    loadfile = id{i}.name;
    load(loadfile);
    
    if size(nFollowed,1) > 1
        temp.nFollowing = nFollowing';
        temp.nFollowed = nFollowed';
        temp.nFavorite = nFavorite';
        temp.nTweets = nTweet';
        temp.hasUrl = hasUrl';
        temp.hasImage = hasImage';
    else
        temp.nFollowing = nFollowing;
        temp.nFollowed = nFollowed;
        temp.nFavorite = nFavorite;
        temp.nTweets = nTweet;
        temp.hasUrl = hasUrl;
        temp.hasImage = hasImage;
    end
    
    temp = degree_percentage(temp, follower_th, tweets_th, favorite_th);
    A = temp;
    
    result_median(1,i) = A.median_follower;
    result_median(2,i) = A.median_following;
    result_median(3,i) = A.median_tweets;
    result_median(4,i) = A.median_favorite;
    
    result_percentage(1,i) = A.follower_percentage;
    result_percentage(2,i) = A.tweets_percentage;
    result_percentage(3,i) = A.favorite_percentage;
    result_percentage(4,i) = A.defautImage_percentage;
end
%% visualization
figure;
hold on;
for i = 1:type
    plot(result_percentage(1,i),result_percentage(2,i),'Color',id{i}.color,'Marker',id{i}.marker,...
        'MarkerSize',id{i}.size,'LineStyle','none','LineWidth',2);
end

legend('Agence France-Presses','Arab News', 'Bangkok Post News','Daily News Egypt',...
     'Financial Times','Foreign Policy','Global Times','Hurriyet Daily News',...
     'Los Angeles Times','People''s Daily China','USA Today','Vladimir Putin','Xinhua News',...
     'Location','SouthEast');

xlabel('Percentage of followers with fewer than 5 followers','FontSize',20); 
ylabel('Percentage of followers with fewer than 5 tweets','FontSize',20);
axis([0 0.7 0 0.700001]);
set(gca,'xticklabel',{'0%','10%', '20%', '30%', '40%' ,'50%','60%','70%'});
set(gca,'yticklabel',{'0%','10%', '20%', '30%', '40%' ,'50%','60%','70%'});
 
figure;
hold on;
for i = 1:type
    plot(result_percentage(4,i),result_percentage(3,i),'Color',id{i}.color,'Marker',id{i}.marker,...
        'MarkerSize',id{i}.size,'LineStyle','none','LineWidth',2);
end

legend('Agence France-Presses','Arab News', 'Bangkok Post News','Daily News Egypt',...
     'Financial Times','Foreign Policy','Global Times','Hurriyet Daily News',...
     'Los Angeles Times','People''s Daily China','USA Today','Vladimir Putin','Xinhua News',...
     'Location','SouthEast');
 
xlabel('Percentage of followers with a default egg image','FontSize',20);
ylabel('Percentage of followers with zero favorite','FontSize',20);
axis([0 0.7 0 0.700001]);
set(gca,'xticklabel',{'0%','10%', '20%', '30%', '40%' ,'50%','60%','70%'});
set(gca,'yticklabel',{'0%','10%', '20%', '30%', '40%' ,'50%','60%','70%'});