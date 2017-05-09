(defconst raml-mode-version "0.0.2"
  "Version of `raml-mode`.")

(defvar raml-mode-hook nil)
(add-to-list 'auto-mode-alist '("\\.raml\\'" . raml-mode))

(defvar raml-indent-offset 4
  "Indent offset for RAML mode")


(defvar raml-keywords
  '("displayName" "description" "type" "string" "number" "integer" "date" "boolean" "file" "enum"
    "pattern" "minLength" "maxLength" "minimum" "maximum" "example" "repeat" "default" "title"
    "version" "baseUri" "mediaType" "schemas" "baseUriParameters" "bucketName" "protocols" "content"
    "body" "applications/json" "text/xml" "get" "put" "delete" "schema" "headers"))


;; (defvar raml-keywords
;;   '("annotationTypes" "baseUri" "baseUriParameters" "body" "content" "description" "documentation"
;;     "mediaType" "properties" "protocols" "resourceTypes" "responses" "schemas" "securedBy"
;;     "securitySchemes" "title" "traits" "type" "types" "uses" "version"))

(defvar raml-constants '("true" "false" "nil"))

(defvar raml-font-lock-defaults
  `((("\\(^ */[a-zA-Z/{}]+\\)" . font-lock-type-face)
     ( ,(concat "^ *" (regexp-opt raml-keywords 'words)) . font-lock-keyword-face)
     ( ,(regexp-opt raml-constants 'words) . font-lock-constant-face))))

(define-derived-mode raml-mode yaml-mode
  "RAML mode"
  (setq font-lock-defaults raml-font-lock-defaults)
  (when raml-indent-offset
    (setq yaml-indent-offset raml-indent-offset)))


(provide 'raml-mode)
