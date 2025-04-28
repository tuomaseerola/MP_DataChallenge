library(stringr)

feature_category<-feature_names
feature_category<-str_replace_all(feature_category, ".*RMSenergy.*", "Dynamics")
feature_category<-str_replace_all(feature_category, ".*jitterLocal*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*shimmerLocal*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*HNR.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*MFCC.*", "MFCC")  
feature_category<-str_replace_all(feature_category, ".*mfcc.*", "MFCC")  
feature_category<-str_replace_all(feature_category, ".*spectralFlux.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralCentroid.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralEntropy.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralSpread.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralSkewness.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralKurtosis.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralSlope.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralDecrease.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralRollOff.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralFlatness.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralFlux.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralRolloff.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*spectralSpread.*", "Timbre")
feature_category<-str_replace_all(feature_category, ".*_zcr_.*", "Timbre")


feature_category<-str_replace_all(feature_category, ".*F0.*", "Pitch")


feature_category

