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
  bin <- xrprof_bin()

  if (!needs_sudo(bin)) {
    p <- processx::process$new(
      bin, args = c("-F", frequency, "-d", duration, "-p", pid),
      stdout = file, stderr = "|", supervise = TRUE
    )
  } else {
    pw <- askpass::askpass("A password is required for sudo:")
    p <- processx::process$new(
      "sudo", args = c("-S", bin, "-F", frequency, "-d", duration, "-p", pid),
      stdin = "|", stdout = "|", stderr = "|", supervise = TRUE
    )
    p$write_input(pw)
    p$write_input("\n")
  }

  p$wait(1)

  if (!p$is_alive()) {
    raw <- p$read_error_lines()
    if (length(raw) == 0) {
      stop("The xprof process failed to start correctly.")
    } else {
      stop(
        "The xprof process failed to start.\n",
        paste("  ", raw, collapse = "\n")
      )
    }
  }

  p
}

#' @rdname xrprof
#' @export
enable_no_sudo <- function() {
  bin <- xrprof_bin()
  pw <- askpass::askpass("A password is required for sudo:")
  p <- processx::process$new(
    "sudo", args = c("-S", "setcap", "cap_sys_ptrace=eip", bin),
    stdin = "|", stdout = "|", stderr = "|", supervise = TRUE
  )
  p$write_input(pw)
  p$write_input("\n")
  p$wait(timeout = 3)
  invisible(p)
}

xrprof_bin <- function() {
  sys <- Sys.which("xrprof")
  vendored <- system.file("vendor", "xrprof", package = "xrprof")
  if (nchar(sys) != 0) {
    sys
  } else if (file.exists(vendored)) {
    vendored
  } else {
    stop("xrprof is not installed locally and no vendored binary is available.")
  }
}

needs_sudo <- function(bin) {
  out <- processx::run("getcap", args = bin)
  if (length(out$stdout) > 0 && grepl("cap_sys_ptrace", out$stdout)) {
    FALSE
  } else {
    message("sudo is currently required to use xrprof. Try using enable_no_sudo() to fix this.")
    TRUE
  }
}
