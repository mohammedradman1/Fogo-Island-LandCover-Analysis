# 🌍 Fogo Island Land Cover & Species Distribution Analysis

This repository contains the **R scripts and analysis workflow** developed during the **GeoTraining Summer School** (Osnabrück University, funded by DAAD & BMZ).  
The project focuses on **Fogo Island (Cabo Verde)** and investigates the relationship between **land cover types** and the **distribution of introduced species** using remote sensing and statistical methods. 
[🌍 View my StoryMap](https://storymaps.arcgis.com/stories/6802dbad71d34dee9564f5b908e27528)

---

## 📖 Project Overview
- 🌱 **NDVI calculation** from Sentinel-2 imagery  
- 🗺️ **Land cover classification** (agriculture, basaltic rock, forest, settlements, sparse vegetation, ocean)  
- 🔎 **Species distribution analysis** (introduced vs. natural species across land covers)  
- 📊 **Confusion matrix, accuracy, and precision evaluation**  
- 📈 **Correlation analysis** between elevation and land cover  

---

## 🔧 Requirements
The scripts were written in **R (≥ 4.0)** and require the following packages:  

```R
install.packages(c(
  "terra",      # spatial raster data processing
  "sf",         # vector data and coordinate systems
  "dplyr",      # data manipulation
  "ggplot2",    # visualization
  "agricolae",  # statistical tests (ANOVA, Kruskal-Wallis, etc.)
  "car"         # variance tests (e.g., Levene’s test)
))
```
---

## 🤝 Acknowledgment
This project was developed as part of the **GeoTraining Summer School**, hosted by **Osnabrück University** and funded by the **German Academic Exchange Service (DAAD)** and the **Federal Ministry for Economic Cooperation and Development (BMZ)**.  

We gratefully acknowledge the contributions of the coordinators, lecturers, and partner institutions who provided invaluable guidance and support throughout the program.  

---

## 📜 License
This repository is released under the **MIT License**.  
You are free to use, modify, and distribute this code for academic and research purposes, provided that proper credit is given to the author.  

---
## 🎥 Presentation
The interactive project presentation is available on **ArcGIS StoryMap**:  
🔗 [View StoryMap Presentation](https://arcg.is/1ODn1i0)  

---
