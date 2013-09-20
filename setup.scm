#!/bin/sh
#|
exec csi -s "$0" "$@"
|#

(let ((args (argv)))
  (when (null? (cdddr args))
    (printf "USAGE: ~A <install_directory>\n" (car args))
    (exit))
  (let ((dest-dir (cadddr args)))
    (printf "dest-dir: ~A\n" dest-dir)))
