(use coq-au-vin)
(use cav-db-sqlite)
(include "cav-web-fcgi.scm")

(enable-sqlite)

(setup-db "data/demo.db")

(app-init content-path: "data/content"
          open-connection: (lambda () (open-database "data/demo.db"))
          template-path: "dynamic/templates")

(config-set!
  '(urlScheme . "http") '(hostName . "quahog") '(bodyMD . "") '(jquerySrc . "/scripts/jquery.js")
  '(canEdit . #t) '(copyright_year . 2013) '(copyright_holders . "Madeleine C St Clair")
  '(rights_statement . "You have no rights") '(htmlTitle . "Civet Page!") '(bodyClasses . ""))

(run)
