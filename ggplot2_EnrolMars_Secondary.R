###GGMAP EXERCISE

library(RCurl)
library(ggmap)
library(ggplot2)
library(dplyr)
library(ggrepel)

# to load the windows fonts to be used
library(extrafont)
windowsFonts(lucida = windowsFont("lucida grande"))


#load the data from github
url <- getURL('https://raw.githubusercontent.com/GrejSegura/DataBank/master/Philippine%2520Open%2520Data/SY%202015%20ENROLMENT%20DATA%20with%20GEOLOCATIONS%20-%20SECONDARY%20(1).csv')

enrol <- read.csv(text = url, header = T)

head(enrol)

#filter the data to show only the maragusan municipality
enrolmars <- enrol %>% filter(municipality == "Maragusan (San Mariano)") %>% mutate(total = year_1_male + year_1_female + year_2_male + year_2_female + year_3_male + year_3_female + year_4_male + year_4_female)

enrolmars

#get the appropriate map using get_map()

map <- get_googlemap(center = c(126.153628, 7.332599), zoom = 12, maptype = 'satellite', crop = FALSE, size = c(640, 450))
m1 <- ggmap(map)
m2 <- m1 + geom_point(aes(x = longitude, y = latitude, size = total, color = school_name), data = enrolmars, alpha = 0.8)
m3 <- m2 + scale_size_area(max_size = 35)
m3


list <- as.vector(enrolmars$school_name)
list <- replace(list, list == "Langgawisan National High School", "Langgawisan NHS")

enrolmars$school_name <- list
enrolmars$school_name

m4 <- m3 + geom_label_repel(data = enrolmars,aes(x = longitude, y = latitude, label = school_name), 
                            
                            
                            segment.color = 'black', force = 15, size = 3, fill = 'gray50', alpha = .5 ,family = 'lucida')
m4
#create different colors for every datapoints 
colorvalue = c("#216c95", "#C0A468", "#D96534", "#D12F19",
               "#88DBA1", "#d08504")

m6 <- m4 + scale_color_manual(values = colorvalue) + ggtitle('Comparative Size of Enrollees in \nMaragusan Public Secondary Schools\n for SY 2015\n')

m7 <- m6 +  theme_minimal() + theme(text = element_text(color = "gray20"),
                                    plot.title = element_text(family = 'lucida', size = 12, face = "bold", vjust = 5),
                                    plot.margin = unit(c(1,1,1,1), "cm"),
                                    legend.position = 'none',
                                    axis.text = element_blank(),
                                    axis.title.x = element_blank(),
                                    axis.title.y = element_blank(),
                                    axis.ticks.y = element_blank(), # element_blank() is how we remove elements
                                    axis.line = element_blank(),
                                    axis.line.y = element_blank(),
                                    panel.grid.major = element_blank(),
                                    panel.grid.major.x = element_blank())
m7
ggsave(filename = "marssecondary.png", plot = m7, dpi = 300, width = 11, height = 7)
