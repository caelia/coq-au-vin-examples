(use cav-db-sqlite)
(include "../common/populate-db.scm")

(enable-sqlite "data/demo.db" "data/content")

(setup-db "data/demo.db")
(populate "data/demo.db")
