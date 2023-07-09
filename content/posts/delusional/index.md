---
title: "Delusional: Can HLTV Rankings be used to predict a CS:GO game's result?"
date: 2022-05-23T00:02:04-03:00
draft: false
type: post
---

During PGL Antwerp 2022 CS:GO Major championships, the biggest brazilian CS:GO streamer,
Gaules, proposed to follow's HLTV rankings to predict the outcome of Major Matches in the
challenger's stage, to help them having an idea of their pick'em inside the game. During
the streams, also was discussed "the bo1 factor", that in best of one matches, you have
better chances of upsets than best of three.

HLTV is the biggest Counter Strike News channel around, and it publishes weekly rankings
that considers the past wins and losses for a team. It weighs tournaments based on how many
days passed, the importance of the tournament, if the tournament was online or not, and other
metrics. [You can find the latest ranking here](https://www.hltv.org/ranking/teams).

So, the thesis is that if the team is higher in this rank, he'll have more probability of winning
a match, so you should bet on it. Its often told in the streams to take the "Adult Choice", where
you don't choose a team based on what you think about it, rather you just pick the one that have
the better performance, that is reflected on its position in the ranking.

Actually, during the first two rounds of matches in the last Major, 14 out 16 results followed the Gaules
methodology, where the better ranked team won the match. But will this stand up historically?
I've scrapped over 1000 CS:GO maches to analyse this idea.

## Gathering the data

HLTV is a backend-rendered website, that does not provide an API to retreive matches' result.
This way, I created a set of python scripts that were able to:

- Retrevie the raking of a given team on a given date (only top 30 teams)
- For a given match, retreive the winning team, losing team, match class (bo1, bo3, bo5) and date of a match
- Retreive a list of all matches in HLTV's website

With that, we can build a database of matches, rankings and results. In the end, I've exctrated the following
features from the data:

- **better_team_won** -> Our target variable, indicates if the better ranked team at that time won the match
- **ranking_diff** -> Raking of the better team minus ranking of the worse team
- **match_class** -> If the match is bo1, bo3 or bo5

Using the rankings from 2021 and 2022, I've be able to select 1177 matches to run the study, divided in 80% for
training and 20% for tests.

Here is a sample of the data:

| better_team_won |	ranking_diff | match_class | winning_team | losing_team | winning_rank | losing_rank | match_date
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | 2 | bo1 | /team/9565/vitality | /team/6665/astralis | 10 | 8 | 1652124000
| 1 | 4 | bo1 | /team/9215/mibr | /team/9996/9z | 24 | 28 | 1652122500
| 1 | 7 | bo1 | /team/4869/ence | /team/11595/outsiders | 2 | 9 | 1652119800
| 1 | 4 | bo1 | /team/8135/forze | /team/11518/bad-news-eagles | 21 | 25 | 1652115900

## Exploratory Analysis

To gather a baseline for the study, its important to notice the the favourite team wins **only 60.57% on average**, which
means that upsets are common. This sets our baseline: to build a model that is able to give us better percentages than the average,
so we can predict better results than just looking at the website.

In the end, we want the model to overweight mathces which one side is favourite, and take away percentages from even teams. This
way we don't bet on teams that has a higher chance to lose a match.

One thing that I noticed is that does not matter that much if the match is best of 1 or best of 3, but if the match is best of 5,
the favourite team gets a huge advantage. Maybe the worse teams choke at finals?

![Percentages Chart](https://i.imgur.com/uVbNOwO.png)


## Running the model

For this study, I've chosen Binomial Regression Model, since I want to get the probability of the better team winning. This way,
I've dumped the data into a sqlite database, and using `pandas` and `statsmodels` packages its possible to came up with the following
model:

```
                 Generalized Linear Model Regression Results                  
==============================================================================
Dep. Variable:        better_team_won   No. Observations:                  942
Model:                            GLM   Df Residuals:                      938
Model Family:                Binomial   Df Model:                            3
Link Function:                  Logit   Scale:                          1.0000
Method:                          IRLS   Log-Likelihood:                -622.12
Date:                Fri, 13 May 2022   Deviance:                       1244.2
Time:                        10:02:47   Pearson chi2:                     941.
No. Iterations:                     4   Pseudo R-squ. (CS):            0.01134
Covariance Type:            nonrobust                                         
================================================================================
                   coef    std err          z      P>|z|      [0.025      0.975]
--------------------------------------------------------------------------------
Intercept        0.2621      0.158      1.655      0.098      -0.048       0.572
ranking_diff     0.0372      0.012      3.036      0.002       0.013       0.061
bo1             -0.0598      0.194     -0.308      0.758      -0.440       0.320
bo3             -0.0898      0.151     -0.596      0.551      -0.385       0.205
bo5              0.4116      0.399      1.032      0.302      -0.370       1.194
================================================================================
```

Then I proceed to find the best cutoff to make decisions based on the model. Experimenting with 70%, 65%, 60% and 50%, I found that
60% cutoff gives the best balance between accuracy and meaningful results. Because its a simple model, majority of the matches falls
under 50%-60% win rate probability, and only really unfair matches (ranking_diff > 18) gives more than 70% of winning chances for the
better team.

60% gives us flexibility to use the model to make decisions, while excluding majoirity of even matches from a decision point of view.

In the test data, the winning rate was only around 54% for the favourite, so because we're expecting better prediction results, a cutoff of
60% should be enought to get consistent results.

With this cutoff, we get around 60% accuracy, in line with just picking from HLTV's website.

## Predicting second phase mathes

Using this results, its possible to predict the Legend's stage of the major. Applying the current ranking of the teams, with a cutoff of 60%,
we can predict that:

| match |	ranking_diff | winning_team | probability
| --- | --- | --- | --- | 
| Heroic x Liquid | 8 | Heroic | 62.23%
| CPH Flames x Bad News Eagles | 12 | CPH Flames | 65.57%
| Cloud9 x Outsiders | 6 | Cloud9 | 60.47%
| Furia x Spirit | 16 | Furia | 68.93%
| Big x Imperial | 17 | Big | 69.72%

The other matches gave less than 60% of probability for the favourite team, and beacuse of that, were excluded from this analysis.

If you decide to bet on those teams, thats the odds from a betting website:

![Odds](https://i.imgur.com/AFXilYA.png)

## Comparing against actual results

Now that the Major is over, we can compare the predicted results with the actual ones:

| match |	ranking_diff | winning_team_predicted | probability | winning_team | profit (10 USD bet)
| --- | --- | --- | --- |  --- | --- |
| Heroic x Liquid | 8 | Heroic | 62.23% | Heroic | 15.20
| CPH Flames x Bad News Eagles | 12 | CPH Flames | 65.57% | CPH Flames | 15.70
| Cloud9 x Outsiders | 6 | Cloud9 | 60.47% | Cloud9 | 15.00
| Furia x Spirit | 16 | Furia | 68.93% | Spirit | -10.00
| Big x Imperial | 17 | Big | 69.72% | Big | 15.60

Only one upset from Spirit, that managed to get to the semi finals in that tournament, and probably will be ahead of Furia in
the next rankings.

With this, betting 50 USD, you've won 51.5 USD, a small profit that does not justify applying the statistical method at all. Which is expected
as the odds adjusts in favor of the favourite, so its expected 0 returns from bets when applying statistical methods, thats better than
the negative expected return when betting without any sort of information.

## Final toughts

There are many factors that can affect the outcome of a match. Considering the HLTV Ranking as the primary one is the same than saying that
past perfomance justifies future performance, which is not true in all cases. CS:GO is a game that tends to the equilibrium, and generally
speaking, wins the team that is most consistent and makes fewer mistakes.

That said, the model is valid, and gives better results that just looking at HLTV alone. In the end, as were said in the stream many times,
any team can win any team, and not having a probability higher than 70% for one team proves that point.

Thanks!
