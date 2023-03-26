## you will learn the basic priciples of working with data frames
## provided by DataFrames packages

## Data Frames objects are flexible data structures that allow
## you to work with tabular data

## Each row has the same number of cells and provides information
## about one observation.



## To work with database of puzzles, 
## we first need to download it from the web
## uncompress
## and read it into a DataFrame


import Downloads

#@info Downloads.download("https://database.lichess.org/lichess_db_puzzle.csv.bz2",
#"puzzles.csv.bz2")

Downloads.download("https://raw.githubusercontent.com/daniel-rojsanch/Gallery-R/main/data/FIFA2.csv", "data/fifa.csv")

## Una forma de comprobar si tenemos el archivo
isfile("data/fifa.csv") 


## otra manera y si no esta pues que nos lo descargue.
if isfile("data/fifa.csv")
    @info "ya exite el archivo"
else
    @info "vamos a descargarlo"
    Downloads.download("https://raw.githubusercontent.com/daniel-rojsanch/Gallery-R/main/data/FIFA2.csv", "data/fifa.csv")
end




## Loading de data as DataFrame
using CSV
using DataFrames


data = CSV.read("data/fifa.csv", DataFrame);
data

names(data)

using Plots
using StatsPlots
@df data scatter(:Age, :Overall)

