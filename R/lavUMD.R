# UMD: universal description of a statistical model
# Y.R. 14 aug 2012, based on the parameterTable in lavaan 0.4

# constructor
lavUMD <- function(table=list(), def=list(), ceq=list(), cin=list()) {
 
    # initialize ref class
    lavR <- lavRefUMD$new(table = table, def = def, ceq = ceq, cin = cin)

    lavR 
}

lavRefUMD <- setRefClass("lavUMD",

# fields
fields = list(
    table     = "list",   # the parameter table
    names     = "list",   # ov.names, lv.names, ...
    flags     = "list",   # meanstructure, ...
    def       = "list",   # def.functions
    ceq       = "list",   # eq constraints
    cin       = "list"    # ineq constraints
),

# methods
methods = list(

initialize = function(table, def, ceq, cin) {
    # check input

    # assign
    table <<- table
    def   <<- def
    ceq   <<- ceq
    cin   <<- cin

    # update names/flags
},

show = function() {
    print(as.data.frame(table))
}

))


              
