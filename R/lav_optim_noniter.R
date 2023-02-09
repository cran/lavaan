# YR 19 September 2022
#
# Entry function to handle noniterative estimators


lav_optim_noniter <- function(lavmodel = NULL, lavsamplestats = NULL,
                              lavpartable = NULL, lavpta = NULL,
                              lavdata = NULL, lavoptions = NULL) {

    # no support for many things:
    if(lavmodel@ngroups > 1L) {
        stop("lavaan ERROR: multiple groups not supported (yet) with optim.method = \"NONITER\".")
    }

    if(lavdata@nlevels > 1L) {
        stop("lavaan ERROR: multilevel not supported (yet) with optim.method = \"NONITER\".")
    }

    # no support (yet) for nonlinear constraints
    nonlinear.idx <- c(lavmodel@ceq.nonlinear.idx,
                       lavmodel@cin.nonlinear.idx)
    if(length(nonlinear.idx) > 0L) {
        stop("lavaan ERROR: nonlinear constraints not supported (yet) with optim.method = \"NONITER\".")
    }

    # no support (yet) for inequality constraints
    if(!is.null(body(lavmodel@cin.function))) {
        stop("lavaan ERROR: inequality constraints not supported (yet) with optim.method = \"NONITER\".")
    }

    # no support (yet) for equality constraints
    if(length(lavmodel@ceq.linear.idx) > 0L) {
        stop("lavaan ERROR: equality constraints not supported (yet) with optim.method = \"NONITER\".")
    }

    # lavpta?
    if(is.null(lavpta)) {
        lavpta <- lav_partable_attributes(lavpartable)
    }


    # extract current set of free parameters
    x.old <- lav_model_get_parameters(lavmodel)
    npar <- length(x.old)


    # fabin?
    ok.flag <- FALSE
    if(lavoptions$estimator %in% c("FABIN2", "FABIN3")) {
        x <- try(lav_cfa_fabin_internal(lavmodel = lavmodel,
                 lavsamplestats = lavsamplestats, lavpartable = lavpartable,
                 lavpta = lavpta, lavoptions = lavoptions), silent = TRUE)
    } else if(lavoptions$estimator == "GUTTMAN1952") {
        x <- try(lav_cfa_guttman1952_internal(lavmodel = lavmodel,
                 lavsamplestats = lavsamplestats, lavpartable = lavpartable,
                 lavpta = lavpta, lavoptions = lavoptions), silent = TRUE)
    } else if(lavoptions$estimator == "BENTLER1982") {
        x <- try(lav_cfa_bentler1982_internal(lavmodel = lavmodel,
                 lavsamplestats = lavsamplestats, lavpartable = lavpartable,
                 lavpta = lavpta, lavoptions = lavoptions), silent = TRUE)
    } else {
        warning("lavaan WARNING: unknown (noniterative) estimator: ",
                lavoptions$estimator, " (returning starting values)")

    }
    if(inherits(x, "try-error")) {
        x <- x.old
    } else {
        ok.flag <- TRUE
    }

    # closing
    fx <- 0
    attr(fx, "fx.group") <- rep(0, lavmodel@ngroups)
    if(ok.flag) {
        attr(x, "converged") <- TRUE
        attr(x, "warn.txt")  <- ""
    } else {
        attr(x, "converged") <- FALSE
        attr(x, "warn.txt")  <- "noniterative estimation failed"
    }
    attr(x, "iterations") <- 1L
    attr(x, "control") <- list()
    attr(x, "fx") <- fx

    x
}
