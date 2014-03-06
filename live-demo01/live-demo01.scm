(use coq-au-vin)
(use cav-db-sqlite)
(use cav-web-fcgi)

(include "../common/populate-db.scm")

(enable-sqlite "data/demo.db" "data/content")

(setup-db "data/demo.db")
(populate "data/demo.db")

(app-init template-path: "dynamic/templates")

(config-set!
  '(url_scheme . "http") '(host_name . "quahog") '(body_md . "") '(jquery_src . "/scripts/jquery.js")
  '(can_edit . #t) '(copyright_year . 2013) '(copyright_holders . "Madeleine C St Clair")
  '(rights_statement . "You have no rights") '(html_title . "Civet Page!") '(body_classes . ""))

(run 4567)
