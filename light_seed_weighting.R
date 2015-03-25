# Load Data matches
matches <- read.csv("Data/sample_submission.csv", header = TRUE, stringsAsFactors = FALSE)
# Load Data seeds
seeds <- read.csv("Data/tourney_seeds.csv", header = TRUE, stringsAsFactors = FALSE)

matches$year <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][1]})
matches$lowId <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][2]})
matches$highId <- sapply(matches$id, FUN=function(x) {strsplit(x, split='[_]')[[1]][3]})

seeds <- subset(seeds, season >= 2011)
seeds$seedNumber <- as.numeric(substring(seeds$seed, 2, 3))

matches <- cbind(matches, merge(matches, seeds, by.x=c("year","lowId"), by.y=c("season","team"))["seedNumber"])
colnames(matches)[6] <- "lowIdSeed"

test <- merge(matches, seeds, by.x=c("year","highId"), by.y=c("season","team"))
test <- test[order(test$id), ]

matches <- cbind(matches, test["seedNumber"])
colnames(matches)[7] <- "highIdSeed"
rownames(matches) <- NULL

matches$calculated <- 0.50 + (matches$highIdSeed - matches$lowIdSeed)*0.0295
# Submit data
submit <- data.frame(id = matches$id, pred = matches$calculated)
# Write file
write.csv(submit, file = "Output/light_simple_seed_295.csv", row.names = FALSE, quote=FALSE)
