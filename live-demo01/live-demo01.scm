(use coq-au-vin)
(use cav-db-sqlite)
(include "../common/cav-web-fcgi.scm")
(include "../common/populate-db.scm")

(enable-sqlite "data/demo.db" "data/content")

(setup-db "data/demo.db")
(populate "data/demo.db")

(app-init template-path: "dynamic/templates")

(config-set!
  '(urlScheme . "http") '(hostName . "quahog") '(bodyMD . "") '(jquerySrc . "/scripts/jquery.js")
  '(canEdit . #t) '(copyright_year . 2013) '(copyright_holders . "Madeleine C St Clair")
  '(rights_statement . "You have no rights") '(htmlTitle . "Civet Page!") '(bodyClasses . ""))

(run 4567)
