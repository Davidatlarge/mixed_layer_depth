MLD.DK <- function(depth, # vector for depth, can be negative but results will be positive
                   variable, # temperature or density
                   threshold, # defines the threshold value that markes the end of the MLD
                   depth.max = max(abs(depth)) # maximum depth to be plotted, uses absolute value of max depth if no value is supplied
)
{
  depth <- abs(depth) # in case depth values are negative
  threshold <- abs(threshold) # in case threshold is provided negative
  data <- data.frame(depth, variable) # combines depth and variable into df
  data$delta <- abs(unique(data$variable[data$depth==min(data$depth)]) - data$variable) # unique() in case the min(depth) occures more than once
  if(depth.max==max(depth)) {print("no depth.max supplied, using max(depth) instead")}
  if(max(data$delta)<threshold) # test if the threshold is exceeded at any depth
  {
    plot(variable, depth, ylim = c(depth.max,0), xlim = c(min(variable)-threshold*2, max(variable)+threshold*2)) # plots variable over depth
    abline(v = c(variable[depth==min(depth)]+threshold, variable[depth==min(depth)]-threshold), col = "red") # draws vertical lines where the threshold of variable is
    text(x = variable[depth==min(depth)], y = min(depth), "<- threshold ->", col = "red", pos = 3, offset = 0.2) 
    print(paste("The thereshold is not exceeded. The water column is well mixed to the maximum depth of", max(depth),"[units of variable]",sep=" "))
    MLD <- NA
    return(MLD)
  }
  else # run if water is stratified according to threshold
  {
    MLD <- min(data$depth[data$delta>=threshold]) # finds the lowest depth for all samples that exceed the threshold
    plot(variable, depth, ylim = c(depth.max,0)) # plots variable over depth
    abline(h = MLD, col = "red") # adds a horizontal line crossing y (depth) at MLD
    text(x = mean(variable), y = MLD, paste("MLD =",MLD), col = "red", pos = 3) # adds text above (pos = 3) the line to the plot
    print(paste("mixed layer depth is", MLD, "[units of depth]", sep = " ")) # prints the result in text form
    return(MLD) # writes the MLD into an object
  }
}
