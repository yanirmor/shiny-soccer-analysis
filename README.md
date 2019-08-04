# <img align="left" height="40px" src="www/icons/soccer.png"></img> Soccer Analysis

Demonstration of network analysis and visualization in R  
[https://yanirmor.shinyapps.io/soccer-analysis](https://yanirmor.shinyapps.io/soccer-analysis)  

### About

This app demonstrates network analysis and visualization in R, with dplyr and ggplot2.  
It is based on data from real soccer games that was adapted and made anonymous, per the request of the original data owner.

### Details

A soccer pitch is divided to 18 equal zones, and displayed as a nodes & edges graph.  

**Big nodes** represent ball "touches" (passes, shots and dribbles).  
Their size scales with the number of touches, and their position is the average position of touches in each zone.
        
**Edges** represent passes between zones.  
Their width scales with the number of passes.

**Small nodes** represent the most contributing player in each zone.  
The position of each player-node is the average position of the player's touches.

### Author
Author: Yanir Mor  
Email: contact@yanirmor.com  
Website: [https://www.yanirmor.com](https://www.yanirmor.com)

### Credits

* Base pitch plot adapted from [GitHub FCrSTATS](https://github.com/FCrSTATS/Visualisations)  
* Icon by [Ivan Boyko / Iconfinder](https://www.iconfinder.com/visualpharm) (CC BY 3.0)

---
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
Copyright © 2019 Yanir Mor
