(use cav-db-sqlite)
(include "../common/populate-db.scm")

(enable-sqlite)

(setup-db "data/demo.db")
(populate "data/demo.db")
