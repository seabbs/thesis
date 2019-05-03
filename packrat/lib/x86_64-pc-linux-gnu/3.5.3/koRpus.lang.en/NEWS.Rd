\name{NEWS}
\title{News for Package 'koRpus.lang.en'}
\encoding{UTF-8}
\section{Changes in koRpus.lang.en version 0.1-2 (2018-03-20)}{
  \subsection{unreleased}{
    \itemize{
      \item this release is under development
    }
  }
  \subsection{fixed}{
    \itemize{
      \item package name in license header
    }
  }
  \subsection{changed}{
    \itemize{
      \item updated README.md
    }
  }
  \subsection{added}{
    \itemize{
      \item support optional arguments for \code{koRpus::set.lang.support()}
    }
  }
  \subsection{temporary}{
    \itemize{
      \item this is planned to be a CRAN-only transitional release. since this
        package needs koRpus >=0.11-2 but the CRAN version (0.10-2) should be upgraded
        after this package was already accepted, we'll work around this by
        deactivating functionality unavailable to older koRpus versions, if such an old
        package is used
      \item temporarily lowered koRpus dependency to 0.10-2
      \item added a check for koRpus version to \code{.onAttach()}, so that the language
        support which is already present won't be tampered with; i.e., you can safely
        load this package with older koRpus packages, it just won't add anything
    }
  }
}
\section{Changes in koRpus.lang.en version 0.1-1 (2018-01-05)}{
  \subsection{changed}{
    \itemize{
      \item initial release as standalone package
    }
  }
}
