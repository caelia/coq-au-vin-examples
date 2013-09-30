;;; cav-web-fcgi.scm -- FastCGI front end for Coq-au-Vin
;;;
;;;   Copyright © 2013 by Matthew C. Gushee <matt@gushee.net>
;;;   This program is open-source software, released under the
;;;   BSD license. See the accompanying LICENSE file for details.

(use coq-au-vin)
(use cav-db-sqlite)
(use fastcgi)
(use uri-common)
(use matchable)

(define (log-obj msg obj #!optional (logfile "obj.log"))
  (with-output-to-file
    logfile
    (lambda ()
      (print msg)
      (pp obj))))

;;; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
;;; ------------------------------------------------------------------------

(define (request-handler in out err env)
  (let* ((alist-stref
           (lambda (key alist)
             (alist-ref key alist string=?)))
         (env* (env))
         (method (alist-stref "REQUEST_METHOD" env*))
         (path-str (alist-stref "REQUEST_URI" env*))
         (qstring (alist-stref "QUERY_STRING" env*))
         (query (form-urldecode qstring))
         (offset (alist-ref 'offset query))
         (path (uri-path (uri-reference path-str)))
         (spec (list path method offset))
         (send-page
           (lambda (type data)
             (let ((len (string-length data)))
               (out (sprintf "Content-type: ~A\r\n" type))
               (out (sprintf "Content-length: ~A\r\n\r\n" len))
               (out data))))
         (send-html
           (lambda (data)
             (send-page "text/html" data)))
         (send-json
           (lambda (data)
             (send-page "application/json" data))))
    ; (logerr (with-output-to-string (lambda () (pretty-print env*))))
    (match spec
      [(or ((/ "") "GET" #f) ((/ "articles") "GET" #f))
       (send-html (get-article-list-page/html out: #f))]
      [(or ((/ "") "GET" #f) ((/ "articles") "GET" ofs))
       (send-html (get-article-list-page/html out: #f offset: (string->number ofs)))]
      [((/ "articles" "new") "GET" _)
       (send-html (get-new-article-form/html out: #f))]
      [((/ "articles" "new") "POST" _)
       (let* ((raw-form (fcgi-get-post-data in env))
              (form-data (form-urldecode raw-form)))
         (send-html (add-article form-data out: #f))]
      [((/ "articles" id/alias) "POST" _)
       (let* ((raw-form (fcgi-get-post-data in env))
              (form-data (form-urldecode raw-form)))
         (send-html (update-article id/alias form-data out: #f))]
      [((/ "articles" id/alias "edit") "GET" _)
       (send-html (get-article-edit-form/html id/alias out: #f))]
      [((/ "articles" id/alias) "GET" _)
       (send-html (get-article-page/html id/alias out: #f))]
      [((or (/ "series") (/ "series" "")) "GET" _)
       (send-html (get-meta-list-page/html 'series #f))]
      [((/ "series" series-title) "GET" #f)
       (send-html (get-article-list-page/html criterion: `(series ,series-title) out: #f))]
      [((/ "series" series-title) "GET" ofs)
       (send-html (get-article-list-page/html criterion: `(series ,series-title) out: #f offset: (string->number ofs)))]
      [((or (/ "tags") (/ "tags" "")) "GET" _)
       (send-html (get-meta-list-page/html 'tags #f))]
      [((/ "tags" tag) "GET" #f)
       (send-html (get-article-list-page/html criterion: `(tag ,tag) out: #f))]
      [((/ "tags" tag) "GET" ofs)
       (send-html (get-article-list-page/html criterion: `(tag ,tag) out: #f offset: (string->number ofs)))]
      [((or (/ "authors") (/ "authors" "")) "GET" _)
       (send-html (get-meta-list-page/html 'authors #f))]
      [((/ "authors" author) "GET" #f)
       (send-html (get-article-list-page/html criterion: `(author ,author) out: #f))]
      [((/ "authors" author) "GET" ofs)
       (send-html (get-article-list-page/html criterion: `(author ,author) out: #f offset: (string->number ofs)))]
      [((or (/ "categories") (/ "categories" "")) "GET" _)
       (send-html (get-meta-list-page/html 'categories #f))]
      [((/ "categories" category) "GET" #f)
       (send-html (get-article-list-page/html criterion: `(category ,category) out: #f))]
      [((/ "categories" category) "GET" ofs)
       (send-html (get-article-list-page/html criterion: `(category ,category) out: #f offset: (string->number ofs)))]
      [_
        (out "Status: 404 Not Found\r\n\r\n")])))

(define (run listen-port)
  (fcgi-accept-loop listen-port 0 request-handler))

;;; OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

;;; ========================================================================
;;; ------------------------------------------------------------------------

; vim:et:ai:ts=2 sw=2
