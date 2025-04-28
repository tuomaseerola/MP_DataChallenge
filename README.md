
## Contents
- <A HREF="#challenge1">Music Psychology Data Challenge 1</A>
- <A HREF="#challenge2">Music Psychology Data Challenge 2</A>


<img src="figures/MP_data_challenge_smaller.png" data-fig-align="right"
width="200" />

<div id="challenge1"></div>

# Music Psychology Data Challenge 1 


This is an internal training exercise for the *Durham Music and Science*
*Music Psychology Lab*, where all members—working individually or in
small groups—are invited to develop models that explain data in a
reliable and robust way. We assume that most participants have a basic
understanding of statistics and are familiar with constructing
regression models, which serves as the foundation for this task.

To make the exercise more challenging and promote the acquiring better
modeling principles, I have built in some inherent challenges to the
task:

1.  We have an abundance of data, particularly predictors
2.  We lack a guiding theory to form our assumptions
3.  We want the analyses to be transparent (notebooks or sets of codes
    that can run independently)

It would be also desirable to be able to explain what the model does in
plain language.

## Explain emotion ratings using acoustic descriptors

For this task, let’s focus on static ratings (a single aggregated mean
rating for the whole excerpt) using static musical features already
extracted from music using MIR tools. We have a good dataset for this.

### Dataset: PMEmo – A Dataset For Music Emotion Computing

Dataset is available at <https://github.com/HuiZhangDB/PMEmo> and fully
at <http://huisblog.cn/PMEmo/>. For more details, see paper by [Zhang et al.,
(2018)](https://doi.org/10.1145/3206025.3206037).

The data allows to explore various aspects of emotion induction,
including (a) predicting arousal and valence from acoustic features, (b)
predicting participants’ electrodermal activity (EDA) from continuous
musical features, and (c) to explore the impact of lyrics or other data
on either of these. Let’s start with the easiest task, predicting the
rated emotions with acoustic features.

#### Loading data

To facilitate analysis and to avoid everyone downloading the full
dataset (1.3 Gb), I share the minimal data in GitHub (just copy this
repository).

``` r
# get static annotations
anno <- read.csv('data/static_annotations.csv',header = TRUE)
# get static acoustic features
feat <- read.csv('data/static_features.csv',header = TRUE)
# combine ratings and features (leave metadata out for now)
df <- merge(anno,feat,by="musicId")
knitr::kable(head(df[,1:7]))
```

| musicId | Arousal.mean. | Valence.mean. | audspec_lengthL1norm_sma_range | audspec_lengthL1norm_sma_maxPos | audspec_lengthL1norm_sma_minPos | audspec_lengthL1norm_sma_quartile1 |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 0.4000 | 0.5750 | 7.318236 | 0.7164319 | 0 | 2.245124 |
| 4 | 0.2625 | 0.2875 | 6.558082 | 0.7033989 | 0 | 1.606873 |
| 5 | 0.1500 | 0.2000 | 8.152512 | 0.3680324 | 0 | 1.404577 |
| 6 | 0.5125 | 0.3500 | 8.527122 | 0.2817285 | 0 | 2.106767 |
| 7 | 0.7000 | 0.7250 | 7.756963 | 0.9589230 | 0 | 3.683783 |
| 8 | 0.3875 | 0.2250 | 9.172951 | 0.5589192 | 0 | 3.131285 |

In the dataframe `df` we have everything we need for the task, where the
first column contains the `musicId` and the columns 2 and 3 are the
arousal and valence mean (ratings) and the rest of the columns are
individual acoustic features. Note the size of the dataset, 767 rows
representing excerpts with 6376 columns representing variables
(`musicId`,`Arousal.mean.`, `Valence.mean.` and 6373 more columns with
exotic names related to audio features).

#### Meta-data (not used in this task)

It might be useful to see the metadata in the `meta` dataframe. If you
wish to get the audio examples, this data is useful to link up the audio
and gives the track names and artist and album names. For a
visualisation, you might want join the two dataframes (`df` and `meta`),
but for the sake of the task, working with `df` is sufficient.

``` r
# get metadata
meta <- read.csv('data/metadata.csv',header = TRUE)
knitr::kable(head(meta))
```

| musicId | fileName | title | artist | album | duration | chorus_start_time | chorus_end_time |
|---:|:---|:---|:---|:---|---:|:---|:---|
| 1 | 1.mp3 | Good Drank | 2 Chainz | Def Jam Presents: Direct Deposit, Vol. 2 | 32.10 | 02:35 | 03:05 |
| 4 | 4.mp3 | X Bitch (feat. Future) | 21 Savage | Savage Mode | 28.09 | 03:00 | 03:26 |
| 5 | 5.mp3 | No Heart | 21 Savage | Savage Mode | 84.23 | 00:41 | 02:03 |
| 6 | 6.mp3 | Red Opps | 21 Savage | Red Opps | 29.53 | 02:16 | 02:44 |
| 7 | 7.mp3 | Girls Talk Boys | 5 Seconds Of Summer | Ghostbusters (Original Motion Picture Soundtrack) | 29.11 | 02:30 | 02:57 |
| 8 | 8.mp3 | PRBLMS | 6LACK | FREE 6LACK | 40.14 | 02:10 | 02:48 |


### Building a good model

To do the modelling properly, consider some of the following steps:

1.  Divide the data into training and testing subsets (typically
    80%/20%) to avoid overfitting.

2.  When building the model, consider normalising your predictors (the
    predictors contain widely different magnitudes, which could be a
    problem for interpretation and developing the models).

3.  When building the model with a training subset, consider
    cross-validation (to avoid overfitting).

4.  Have some kind of feature selection principle (theory, statistical
    operation, intuition, …).

5.  Try to create as simple a model as possible.

6.  Assess the goodness of the model with separate data (the testing
    subset typically serves this purpose).

7.  Explain what explains arousal and valence based on your analysis.

There are plenty of guides about how to create models in R and in
Python, many of them using useful packages designed for building models
such [`caret` package](https://topepo.github.io/caret/index.html) or
[`tidymodels`](https://www.tidymodels.org) or other guides such as
[YaRrr!](https://bookdown.org/ndphillips/YaRrr/). Classic statistics
handbooks will give you solid guidance as well (Howell, 2010; Tabachnick
et al., 2013), some of which come with R code (Lilja and Linse, 2016;
Sheather, 2009; McNulty, 2021).

## To submit your model

You can do the challenge individually or in groups. When you have done
the exercise, you should be able:

1.  to show the analytical steps
2.  to summarise your best model using metrics such as $R^2$
3.  to explain the model by interpreting the model coefficients
4.  to tell others what did you learn while doing the exercise (note:
    fails and dead ends are important part of the learning process)

For the 3rd point, many of the acoustical descriptors might be quite
difficult to interpret from the labels alone, but you can still explain
the model principles even if the computation or the meaning of the exact
feature may not be easily decipher.

Bonus points for visualising the original ratings and the model
predictions.

We want the outcome to be shared as a notebook/document (*Rmarkdown*,
*Quarto*, *Jupyter* or even pure R and Python) that will be able to run
and produce your analysis in any computer (with the same data and
packages). This part of the exercise encourages you to build transparent
models that others will understand and can run.

If you enjoy the task, we could later on try a more challenging variant
related to this where we attempt to explain the electodermal activity
with musical features or bring information from lyrics or metadata to
the models.

<img src="figures/MPL.png" data-fig-align="left" width="160" /> 


### The Winner of the MP Data Challenge 1

**Wei Wu** developed a mature modelling approach for this challenge,
where he took those features that correlated with the ratings and
reduced the number of features through principal component analysis
(PCA). He then used the PCA components to predict the ratings with
proper cross-validation. All submission managed to do meaningful
analyses of the data. One of the takeaways was that the model
development and evaluation needs to be kept separate from the start to
avoid “peeking”.

Congratulations to Wei! 👏🍾👏

* * *

 <div id="challenge2"></div>

# Music Psychology Data Challenge 2

The second music psychology data challenge is about noise and errors.
How do you diagnose and deal with these?

## Priming data

This dataset comes from a priming study, in which participants made quick binary judgements of words as either "negative" or "positive". The words were presented immediately after a sound stimulus (referred to as a "prime" in priming studies), which was either positive or negative (for example, consonant or dissonant sounds). It is a long-established finding that processing incongruous stimuli takes more time than processing congruous ones, so reaction time provides insight into this process, which is not under volitional control. This method allows researchers to explore whether sound associations are genuinely processed as negative or positive, or whether they are simply consciously rated as such when assessed using self-report scales (Armitage et al., 2020; Lahdelma et al., 2024).

### Dataset details

This is a simple experiment. Each participant (*N* = 40) made a decision about word valence across 64 trials (sound primes + word targets). These trials consisted of 8 positive and 8 negative words, presented either congruously with the sound (positive sound and positive word, or negative sound and negative word) or incongruously (negative sound and positive word, or positive sound and negative word). The dependent variable is the reaction time (`reaction_time`) in milliseconds, and the two main independent variables are `congruity` (indicating whether the sound and word were congruous or incongruous) and musical `expertise` (musician or non-musician). Some previous literature suggests that musicians tend to be more sensitive to such nuances in sounds.

This is what the data looks like.

``` r
data <- read.csv('data/MPdata_challenge2_rt_dataset.csv')
knitr::kable(head(data))
```

| subject_id | trial_id | expertise | congruity | reaction_time | is_correct | word | sound | word_label |
|---:|---:|:---|:---|---:|:---|:---|:---|:---|
| 1 | 1 | Non-musician | congruent | 901.4 | TRUE | Pos | Pos | Pos_1 |
| 1 | 2 | Non-musician | congruent | 905.5 | TRUE | Pos | Pos | Pos_2 |
| 1 | 3 | Non-musician | incongruent | 946.7 | FALSE | Pos | Neg | Pos_3 |
| 1 | 4 | Non-musician | congruent | 957.6 | TRUE | Pos | Pos | Pos_4 |
| 1 | 5 | Non-musician | congruent | 946.3 | TRUE | Pos | Pos | Pos_5 |
| 1 | 6 | Non-musician | congruent | 951.1 | TRUE | Pos | Pos | Pos_6 |

There are 2,624 observations in the dataset, which is not exactly correct given that 40 participants each completed 64 trials (40 × 64 = 2,560). This discrepancy suggests that the data contain some errors and noise, in addition to the inherent variability typically seen in reaction time measures.

## Challenge

Was there a statistically significant effect of priming? And was there a difference in reaction times based on expertise? Before conducting the analysis, you should first inspect the data to identify any quality issues and decide how to address them.

> [!TIP]  
> `expand` function (from `tidyr`) helps you to diagnose conditions. 
> `table` function can also be useful.

> [!IMPORTANT]  
> Histograms are helpful. 
> Reaction time data has a feasible range of values.

## Solutions

It is all about learning. Again, submit your solutions as _Rmarkdown_
notebook, preferably divided into two sections:

#### 1. Dealing with errors

In the first part, describe what you do and give a rationale of why you remove/alter any observations. You can
include figures in your solution. 

#### 2. Analysis results

In the second part, you can present a statistical analysis that answers the questions about the priming and expertise.

> [!NOTE] 
> If you wish to engage with study **preregistrations** in future, you will need to specify all these steps in advance of data collection: (1) the criteria for data exclusion, (2) the preprocessing steps, and (3) the specific analysis procedures. It is important to learn to articulate potential issues and their solutions before collecting data.


### The Winner of the MP Data Challenge 2


## References

- Armitage, J., Lahdelma, I., Eerola, T., & Ambrazevičius, R. (2023).
  Culture influences conscious appraisal of, but not automatic aversion
  to, acoustically rough musical intervals. *Plos One, 18(12)*,
  e0294645. <https://doi.org/10.1371/journal.pone.0294645>

- Howell, D. C. (2010). *Statistical methods for psychology*. 7th
  ed. Wadwsworth, Cengage Learning.

- Lahdelma, I. & Eerola, T. (2024). Valenced Priming with Acquired
  Affective Concepts in Music: Automatic Reactions to Common Tonal
  Chords. Music Perception, 41(3), 161-175.
  <https://doi.org/10.1525/mp.2024.41.3.161>

- Lilja, D. J. & Linse, G. M. (2022). *Linear regression using R: An
  introduction to data modeling.* University of Minnesota Libraries
  Publishing.
  https://staging.open.umn.edu/opentextbooks/textbooks/linear-regression-using-r-an-introduction-to-data-modeling

- McNulty, K. (2021). *Handbook of regression modeling in people
  analytics: With examples in R and Python.* Chapman and Hall/CRC.
  https://peopleanalytics-regression-book.org/index.html

- Sheather, S. (2009). *A Modern Approach to Regression with R*.
  Springer Science & Business Media.
  https://link.springer.com/book/10.1007/978-0-387-09608-7

- Tabachnick, B. G., Fidell, L. S., & Osterlind, S. J. (2013). *Using
  multivariate statistics*. Pearson, Boston, MA.

- Zhang, K., Zhang, H., Li, S., Yang, C., & Sun, L. (2018). The PMEmo
  dataset for music emotion recognition. *Proceedings of the 2018 ACM on
  International Conference on Multimedia Retrieval*, 135–142.
  <https://doi.org/10.1145/3206025.3206037>
