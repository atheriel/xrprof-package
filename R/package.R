#' Profile an External R Program
#'
#' \code{xrprof()} is similar to \code{\link[utils]{Rprof}} and produces the same
#' output format, but can be used to profile other running R programs instead.
#'
#' @param file The file to write the samples to. See \code{\link[utils]{Rprof}}.
#' @param pid The process ID to target.
#' @param frequency The frequency to sample at, in hertz.
#' @param duration The length of time to profile, in seconds.
#'
#' @return A \code{\link[processx]{process}} instance.
#'
#' @export
xrprof <- function(file, pid = Sys.getpid(), frequency = 1, duration = 3600) {
  p <- processx::process$new(
    xrprof_bin(), args = c("-F", frequency, "-d", duration, "-p", pid),
    stdout = file, stderr = "|", supervise = TRUE
  )

  if (!p$is_alive()) {
    p$read_error_lines()
  }

  p
}

xrprof_bin <- function() {
  if (nchar(Sys.which("xrprof")) != 0) {
    Sys.which("xrprof")
  } else {
    stop("xrprof is not installed.")
  }
}
