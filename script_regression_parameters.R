#clean workspace
rm(list = ls()) 
library(ggplot2) #dataviz
library(gridExtra) #dataviz

#set working directory to the current source file directory
dir.wd <- "/Users/Marco/Dropbox/R workspace/github/regression_parameters/Regression-parameter-estimates/"

#load dataset
df_hrv_age <- read.csv(paste(dir.wd, "df_hrv_age.csv", sep = ""), header = TRUE)

#plot data (scatterplot with distributions)
#placeholder plot - prints nothing at all
margin_plots <- 0.2
empty <- ggplot() + geom_point(aes(1, 1), colour = "white") + 
  theme(plot.background = element_blank(), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.border = element_blank(), panel.background = element_blank(), axis.title.x = element_blank(), 
        axis.title.y = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), 
        axis.ticks = element_blank())

# scatterplot of x and y variables
scatter <- ggplot(df_hrv_age, aes(age, mean_hrv)) + geom_point() + 
  #scale_color_manual(values = c("orange", "purple")) + 
  scale_x_continuous("Age") + 
  stat_smooth(method = "lm") +
  scale_y_continuous("Heart Rate Variability (rMSSD)") + 
  theme(panel.background = element_rect(fill = 'ghostwhite', colour = 'ghostwhite')) +
  theme(plot.margin = unit(c(margin_plots,margin_plots,margin_plots,margin_plots), "cm")) +
  theme(legend.position = c(1, 1), legend.justification = c(1, 1))

# marginal density of x - plot on top
plot_top <- ggplot(df_hrv_age, aes(age)) + geom_density(alpha = 0.5) + 
  scale_x_continuous("Age") + 
  theme(panel.background = element_rect(fill = 'ghostwhite', colour = 'ghostwhite')) +
  theme(plot.margin = unit(c(margin_plots,margin_plots,margin_plots,margin_plots), "cm")) +
  theme(legend.position = "none")  

# marginal density of y - plot on the right
plot_right <- ggplot(df_hrv_age, aes(mean_hrv)) + geom_density(alpha = 0.5) + 
  coord_flip()  + 
  scale_x_continuous("Heart Rate Variability (rMSSD)") + 
  theme(panel.background = element_rect(fill = 'ghostwhite', colour = 'ghostwhite')) +
  theme(plot.margin = unit(c(margin_plots,margin_plots,margin_plots,margin_plots), "cm")) +
  theme(legend.position = "none") 

# arrange the plots together, with appropriate height and width for each row and column
grid.arrange(plot_top, empty, scatter, plot_right, ncol = 2, nrow = 2, 
             widths = c(4, 1), heights = c(1, 4))

#correlation between variables
rcorr(df_hrv_age$age, df_hrv_age$mean_hrv)

#1 - Least squares
#Manual implementation

#add intercept
X <- cbind(rep(1, length(df_hrv_age$age)), df_hrv_age$age)
y <- df_hrv_age$mean_hrv
  
#use correct operator for matrix multiplcation
#also solve can be used because we have a square matrix after multiplying X for its transpose
B_hat <- (solve(t(X)%*%X) %*% t(X)) %*% y

print(B_hat)

#lm package 
summary(lm(mean_hrv ~ age, data = df_hrv_age))$coefficients














