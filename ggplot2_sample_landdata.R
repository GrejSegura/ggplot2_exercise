#This is an exercise for ggplot2 using the land data

library(RCurl)

urland <- getURL('https://raw.githubusercontent.com/GrejSegura/DataBank/master/landdata/landdata-states-2015q3.csv')

data <- read.csv(text = urland)

#load the necessary libraries
library(ggplot2)
library(dplyr)
library(ggrepel)
# to load the windows fonts to be used
library(extrafont)
windowsFonts(Courier=windowsFont("Courier New"))

head(data)
tail(data)

#examine the data
summary(data[,'Land.Share..Pct.'])

##Get the average for Home Value and Structure Cost per STATE
data1 <- data %>% 
  group_by(STATE) %>% 
  filter(Date == '2015') %>%
  summarise(HV = mean(Home.Value, rm.na = TRUE), SC = mean(Structure.Cost, rm.na = TRUE), Share = median(Land.Share..Pct.))
head(data1)
nrow(data1)


##creating scatter plot to investigate the correlation between Home Value and Structure Cost 

any(is.na(data))


g <- ggplot(data1, 
            aes(x = HV, 
                y = SC, 
                color = STATE)) + geom_point(size = 9, shape = 1)

g1 <- g + geom_point(size = 7, alpha = .7)

##add a smoother
g2 <- g1 + geom_smooth(method = 'lm', 
                       formula = y ~ log(x), 
                       color = '#D12F19', 
                       se = FALSE)
g2

##label the points
statelist <- data1$STATE[1:20]
statelist

#repel the labels

g3 <- g2 + geom_text_repel(aes(label = STATE), 
                           color = "gray10", 
                           data = subset(data1, STATE %in% statelist), 
                           segment.color = 'gray10', force = 5, size = 4, family = 'Courier') #size is to change the font size of the label
g3
g4 <- g3 + scale_y_continuous(name = 'Structure Cost\n') + scale_x_continuous(name = '\nHome Value\n')

#create different colors for every datapoints 
colorvalue = c("#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235", "#A61407", "#5B0400", "#6fcb9f",
               "#00515C", "#fb2e01", "#B38235")

g5 <- g4 + scale_color_manual(values = colorvalue) + ggtitle('Relationship Between Home Value and Structure Cost in the US\n')
g6 <- g5 + geom_text(size = 2)



g6 <- g5 +  theme_minimal() + theme(text = element_text(color = "gray20"),
                                    plot.title = element_text(family = 'Courier', size = 15, face = "bold"),
                                    plot.margin = unit(c(.5,.5,.5,.5), "cm"),
                                    legend.position = 'none',
                                    axis.text = element_text(family = 'Courier', color = 'gray20'),
                                    axis.title.x = element_text(family = 'Courier', vjust = -1, size = 15, face = 'bold'), # move title away from axis, size is the font size
                                    axis.title.y = element_text(family = 'Courier', vjust = 1, size = 15, face = 'bold'), # move away for axis, size is the font size
                                    axis.ticks.y = element_blank(), # element_blank() is how we remove elements
                                    axis.line = element_line(color = "gray40", size = 0.5),
                                    axis.line.y = element_blank(),
                                    panel.background = element_rect(fill = 'gray95', colour = 'gray95'),
                                    plot.background = element_rect(fill = 'gray95', colour = 'gray95'),
                                    panel.grid.major = element_line(color = "gray50", size = 0.5),
                                    panel.grid.major.x = element_blank(),
                                    panel.grid.minor.x = element_blank(),
                                    panel.grid.minor.y = element_blank())
g6

ggsave(filename = "USLand.png", plot = g6, dpi = 1500, width = 11, height = 7)
