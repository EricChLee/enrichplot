##' @rdname pairwise_termsim
##' @exportMethod pairwise_termsim
setMethod("pairwise_termsim", signature(x = "enrichResult"),
    function(x, method = "JC", semData = NULL, showCategory = 30) {
        pairwise_termsim.enrichResult(x, method = method,
            semData = semData, showCategory = showCategory)
    })

##' @rdname pairwise_termsim
##' @exportMethod pairwise_termsim
setMethod("pairwise_termsim", signature(x = "gseaResult"),
    function(x, method = "JC", semData = NULL, showCategory = 30) {
        pairwise_termsim.enrichResult(x, method = method,
            semData = semData, showCategory = showCategory)
    })

##' @rdname pairwise_termsim
##' @exportMethod pairwise_termsim
setMethod("pairwise_termsim", signature(x = "compareClusterResult"),
    function(x, method = "JC", semData = NULL, showCategory = 30) {
        pairwise_termsim.compareClusterResult(x, method = method,
            semData = semData, showCategory = showCategory)
    })


##' @rdname pairwise_termsim
pairwise_termsim.enrichResult <- function(x, method, semData = NULL, showCategory = 30) {
    y <- as.data.frame(x)
    geneSets <- geneInCategory(x)
    n <- update_n(x, showCategory)
    if (n == 0) stop("no enriched term found...")
    if (is.numeric(n)) {
        y <- y[1:n, ]
    } else {
        y <- y[match(n, y$Description),]
        n <- length(n)
    }

    x@termsim <- get_ww(y = y, geneSets = geneSets, method = method,
                semData = semData)
    x@method <- method
    return(x)
}


##' @rdname pairwise_termsim
pairwise_termsim.compareClusterResult <- function(x, method, semData = NULL, 
                                                  showCategory = 30) {
    y <- fortify(x, showCategory=showCategory, includeAll=TRUE, split=NULL)
    y$Cluster <- sub("\n.*", "", y$Cluster)
    y_union <- get_y_union(y = y, showCategory = showCategory)
    geneSets <- setNames(strsplit(as.character(y_union$geneID), "/",
                                  fixed = TRUE), y_union$ID)
    x@termsim <- get_ww(y = y_union, geneSets = geneSets, method = method,
                semData = semData)                              
    x@method <- method
    return(x)
    
}