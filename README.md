# Music Psychology Data challenge


<img src="figures/MP_data_challenge_smaller.png" data-fig-align="left"
width="200" />

This is an internal training exercise for the Durham Music and Science
Music Psychology Lab, where all members—working individually or in small
groups—are invited to develop models that explain data in a reliable and
robust way. We assume that most participants have a basic understanding
of statistics and are familiar with constructing linear regression
models, which serves as the foundation for this task.

To make the exercise more challenging and promote the learning of better
modeling principles, we have built in some inherent obstacles: (1) we
have an abundance of data, particularly predictors, (2) we lack a
guiding theory to form our assumptions, and (3) we want the analyses to
be transparent (notebooks or sets of codes that can run independently).

## Present task: Explain emotion ratings using acoustic descriptors

For this task, let’s focus on static ratings (static ratings means that
there is a single aggregated mean rating for the whole excerpt) using
static musical features already extracted from music using MIR tools. We
have a good dataset for this.

### Dataset: PMEmo – A Dataset For Music Emotion Computing

Dataset is available at <https://github.com/HuiZhangDB/PMEmo> and fully
at <http://huisblog.cn/PMEmo/> and this is the description by the
authors:

> PMEmo dataset contains emotion annotations of 794 songs as well as the
> simultaneous electrodermal activity (EDA) signals. A Music Emotion
> Experiment was well-designed for collecting the affective-annotated
> music corpus of high quality, which recruited 457 subjects.

> The dataset is publically available to the research community, which
> is foremost intended for benchmarking in music emotion retrieval and
> recognition. To straightforwardly evaluate the methodologies for music
> affective analysis, it also involves pre-computed audio feature sets.
> In addition to that, manually selected chorus excerpts (compressed in
> MP3) of songs are provided to facilitate the development of
> chorus-related research.

For more details, see paper by [Zhang et al.,
(2018)](https://doi.org/10.1145/3206025.3206037).

The data allows to explore various aspects of emotion induction,
including predicting arousal and valence from acoustic features and
explaining electrodermal activity (EDA) from continuous musical features
or from lyrics or other data. Let’s start with the easiest task,
predicting the rated emotions with acoustic features.

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
|--------:|--------------:|--------------:|-------------------------------:|--------------------------------:|--------------------------------:|-----------------------------------:|
|       1 |        0.4000 |        0.5750 |                       7.318236 |                       0.7164319 |                               0 |                           2.245124 |
|       4 |        0.2625 |        0.2875 |                       6.558082 |                       0.7033989 |                               0 |                           1.606873 |
|       5 |        0.1500 |        0.2000 |                       8.152512 |                       0.3680324 |                               0 |                           1.404577 |
|       6 |        0.5125 |        0.3500 |                       8.527122 |                       0.2817285 |                               0 |                           2.106767 |
|       7 |        0.7000 |        0.7250 |                       7.756963 |                       0.9589230 |                               0 |                           3.683783 |
|       8 |        0.3875 |        0.2250 |                       9.172951 |                       0.5589192 |                               0 |                           3.131285 |

In the dataframe `df` we have everything we need for the task, where the
first column contains the `musicId` and the columns 2 and 3 are the
arousal and valence mean (ratings) and the rest of the columns are
individual acoustic features.

#### Meta-data (not used in this task)

It might be interesting to see the metadata in the `meta` dataframe. If
you wish to get the audio examples, this data is useful to link up the
audio and gives the track names and artist and album names. For a
visualisation, you might want join the two dataframes (`df` and `meta`),
but for the sake of the task, working with `df` is sufficient.

``` r
# get metadata
meta <- read.csv('data/metadata.csv',header = TRUE)
knitr::kable(head(meta))
```

| musicId | fileName | title                  | artist              | album                                             | duration | chorus_start_time | chorus_end_time |
|--------:|:---------|:-----------------------|:--------------------|:--------------------------------------------------|---------:|:------------------|:----------------|
|       1 | 1.mp3    | Good Drank             | 2 Chainz            | Def Jam Presents: Direct Deposit, Vol. 2          |    32.10 | 02:35             | 03:05           |
|       4 | 4.mp3    | X Bitch (feat. Future) | 21 Savage           | Savage Mode                                       |    28.09 | 03:00             | 03:26           |
|       5 | 5.mp3    | No Heart               | 21 Savage           | Savage Mode                                       |    84.23 | 00:41             | 02:03           |
|       6 | 6.mp3    | Red Opps               | 21 Savage           | Red Opps                                          |    29.53 | 02:16             | 02:44           |
|       7 | 7.mp3    | Girls Talk Boys        | 5 Seconds Of Summer | Ghostbusters (Original Motion Picture Soundtrack) |    29.11 | 02:30             | 02:57           |
|       8 | 8.mp3    | PRBLMS                 | 6LACK               | FREE 6LACK                                        |    40.14 | 02:10             | 02:48           |

### Building a bad model

The simplest model would be a linear regression predicting either
arousal or valence using all features, and it could be done in R using
(`lm`) in the following way:

``` r
naive_model <- lm(Arousal.mean. ~ ., 
  data = dplyr::select(df,-musicId,-Valence.mean.)) # discard the columnd that are not needed
s <- summary(naive_model)
print(round(s$r.squared,3))
```

    [1] 0.999

But this model is *pure nonsense* because it tries to predict 767
ratings with 6373 predictors, and if you have more predictors than
observations, you break any modelling assumptions and you will be
explain all data even with random variables. As we can see, the model is
“perfect” ($r^2$ = 0.999). To predict a variable, you need many more
observations than predictors and the rule is to have 15 or 20 times more
observations than predictors.

Just to demonstrate this, here we predict arousal with 770 random
features, which is equally “good” as the previous silly model.

``` r
n <- nrow(df); reps <- 770; n1 <- 1
# create a data frame with 770 random variables 
tmp<- as.data.frame(cbind(matrix(seq_len(n*n1), ncol=n1),
      matrix(sample(0:1, n*reps, replace=TRUE), ncol=reps)))
tmp$Arousal.mean. <- df$Arousal.mean. # add arousal to random data
random_model <- lm(Arousal.mean. ~ .,data=tmp)
s2 <- summary(random_model)
print(round(s2$r.squared,3))
```

    [1] 1

A perfect prediction obtained with noise! This illustrates that we need
to be selective about the predictors as we can only afford to have a
maximum of 30 predictors if using the rule of 20:1, but consider having
only a handful predictors, if you want to be able to explain the model.

### Building a good model

To do the modelling properly, consider some of the following steps:

1.  Divide the data into training and testing subsets (typically
    80%/20%) to avoid overfitting.

2.  When building the model, think of normalising your predictors (the
    predictors contain widely different magnitudes, which could be a
    problem for interpretation and developing the models.)

3.  When building the model with a training subset, consider
    cross-validation (to avoid overfitting)

4.  Have some kind of feature selection principle (theory, statistical
    operation, intuition, …)

5.  Try to create as simple a model as possible

6.  Assess the goodness of the model with separate data (the testing
    subset typically serves this purpose)

There are plenty of guides about how to create models in R and in
Python, many of them using useful packages designed for building models
such [`caret` package](https://topepo.github.io/caret/index.html) or
[`tidymodels`](https://www.tidymodels.org) or other guides such as
[YaRrr!](https://bookdown.org/ndphillips/YaRrr/).

## To submit your model

You can do the challenge individually or in groups. When you have done
the exercise, you should be able:

1.  to show the analytical steps
2.  to summarise your best model using metrics such as $R^2$
3.  to explain the model by interpreting the model coefficients
4.  to tell others what did you learn while doing the exercise (Note
    that fails are important part of the learning process)

For the 3rd point, many of the acoustical descriptors might be quite
difficult to interpret from the labels alone, but you can still explain
the model principles even if the computation or the meaning of the exact
feature is not known to us.

Bonus points for visualising the original ratings and the model
predictions.

We want the outcome to be shared as a notebook/document (*Rmarkdown*,
*Quarto*, *Jupyter* or even pure R and Python) that will be able to run
and produce your analysis in any computer (with the same data and
packages). This part of the exercise encourages you to build transparent
models that others will understand and can run.

If you enjoy the task, we could try a more challenging variant related
to this where we attempt to explain the electodermal activity with
musical features or bring information from lyrics or metadata to the
models.

<img src="figures/MPL.png" data-fig-align="left" width="160" />

## References

- Zhang, K., Zhang, H., Li, S., Yang, C., & Sun, L. (2018). The PMEmo
  dataset for music emotion recognition. *Proceedings of the 2018 ACM on
  International Conference on Multimedia Retrieval*, 135–142.
  <https://doi.org/10.1145/3206025.3206037>
