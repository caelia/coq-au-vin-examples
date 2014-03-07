(use coq-au-vin)
(use cav-db-sqlite)
(use (prefix cav-db db:))

(enable-sqlite "data/demo.db" "data/content")

(app-init template-path: "dynamic/templates")

(config-set!
  '(url_scheme . "http") '(host_name . "quahog") '(body_md . "") '(jquery_src . "/scripts/jquery.js")
  '(can_edit . #t) '(copyright_year . 2013) '(copyright_holders . "Madeleine C St Clair")
  '(rights_statement . "You have no rights") '(html_title . "Civet Page!") '(body_classes . ""))

(define (create-page-set path #!key (limit 10))
  ((db:connect))
  (let-values (((count list-data) ((db:get-article-list) 'all limit 0 text->teaser)))
    (let ((node_ids (map (lambda (datum) (alist-ref 'node_id datum)) list-data)))
      (with-output-to-file
        (make-pathname path "index" "html")
        (lambda ()
          (get-article-list-page/html limit: limit)))
      (for-each
        (lambda (nid)
          (with-output-to-file
            (make-pathname path nid "html")
            (lambda ()
              (get-article-page/html nid))))
        node_ids)
      ((db:disconnect)))))
