# get the library
library(terra)
# importing data
setwd("C:/Users/Joseph Pascal/Desktop/Geotraining/Data1")
df= read.csv("fogo_plots.csv", h=T, dec=",")
###Convert into Coordinate system
library(sf)
pts <- st_as_sf(df, coords = c("LONG", "LAT"), crs = 4326)  # WGS84
pts_proj <- st_transform(pts, 32626)## EPSG:32626 (UTM Zone 26N)
coords_proj <- st_coordinates(pts_proj)
df_proj <- cbind(df, coords_proj)
head(df_proj)
write.csv(df_proj, "fogo_plot_projected.csv", row.names = FALSE)

##st_write(pts_proj, "fogo_plot_projected.gpkg")  # geopackage
##st_write(pts_proj, "fogo_plot_projected.shp")   # shapefile



df1= read.csv("fogo_species.csv", h=T, dec=",")
Data=merge(df_proj,df1, by="PLOT")
write.csv(Data,"DataSpecies1.csv")
Data=read.csv("DataSpecies1.csv", h=T, dec=",")
Data1=Data[,c("X","Y")]
str(Data1)
Data1$X=as.numeric(Data1$X)
Data1$Y=as.numeric(Data1$Y)
str(Data1)
library(sf)
sentinel= rast("C:/Users/Joseph Pascal/Desktop/Geotraining/Data1/sentinel_output.tif")
plot(sentinel)
plot(sentinel,col=c("darkgreen", "grey10","lightblue", "grey40", "firebrick1", "lightgreen", "limegreen"))
sentinel
## collect all the pixel values 
reference_data= extract(sentinel, Data1)
head(reference_data)
## attach an ID 
Data1$ID= seq(1, nrow(Data1))
reference_data= merge(reference_data, Data, by= "ID")
head(reference_data)
str(reference_data)
Tot=subset(reference_data,SOURCE=="IS")
Tot1=Tot[,c("class","SPECIES")]
Tot1
Cal=table(Tot1$class,Tot1$SPECIES)
Cal
Cal=as.data.frame(Cal)
colnames(Cal) <- c("class", "SPECIES", "NUMB")
library(dplyr)
##remove outliers

CalF <- Cal %>%
  group_by(class) %>%
  filter({
    Q1 <- quantile(NUMB, 0.25)
    Q3 <- quantile(NUMB, 0.75)
    IQR_val <- Q3 - Q1
    NUMB >= (Q1 - 1.5*IQR_val) & NUMB <= (Q3 + 1.5*IQR_val)
  })

boxplot(NUMB~class,data=CalF,col = c(1:8))

# Count number of introduced species per class
Freq_per_class <- Tot1 %>%
  group_by(class) %>%
  summarise(NUMB = n())
Freq_per_class



Mean=table(reference_data$class,reference_data$SOURCE)
Mean
Mean=as.data.frame(Mean)
colnames(Mean) <- c("class", "SOURCE", "NUMB")
Mean_IS <- subset(Mean, SOURCE == "IS")
boxplot(NUMB ~ class, data = Mean_IS,
        xlab = "Class",
        ylab = "Amount of introduces species",
        main = "Amount of introduces species among land cover")

ymax <- max(Mean_IS$NUMB) * 1.15  # 15% higher than the tallest bar
bp=barplot(Mean_IS$NUMB,
        names.arg = Mean_IS$class,
        col = rainbow(nrow(Mean_IS)),  # colorful bars
        main = "Introduces species among land cover",
        xlab = "Land cover",
        ylab = "Number of introduces species",
        las = 2,  # rotate x labels
        ylim = c(0, ymax))
# Add numbers on top of bars
text(x = bp, y = Mean_IS$NUMB, labels = Mean_IS$NUMB, pos = 3, cex = 0.9, font=2,col = "black")

##Check normality and variance
# -------------------------------

# Normality test (Shapiro-Wilk) per class
library(agricolae)
shapiro_results <- CalF %>%
  group_by(class) %>%
  summarise(p_value = shapiro.test(NUMB)$p.value)
shapiro_results

# Levene's test for homogeneity of variance
library(car)
leveneTest(NUMB ~ class, data = CalF)
anova_result <- aov(NUMB ~ class, data = CalF)
summary(anova_result)
# Post-hoc if significant
TukeyHSD(anova_result)
out=HSD.test(anova_result,'class',group=T,console=F,alpha=0.05)
out
kruskal.test(NUMB ~ class, data = CalF)
# Pairwise Wilcoxon (after Kruskal-Wallis)
pairwise.wilcox.test(CalF$NUMB, CalF$class, p.adjust.method = "BH")
