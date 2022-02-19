;; Initialize package sources
(require 'package)

;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(setq package-user-dir (expand-file-name "./.packages"))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)

;; Install use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Install other dependencies
(use-package ox-reveal
;; Exports Org-mode contents to Reveal.js HTML presentation
  :custom
        (org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
        (org-reveal-hlevel 2)
  )


;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      ;; org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
      org-html-head "
<link rel=\"stylesheet\" href=\"https://unpkg.com/sakura.css/css/sakura.css\" type=\"text/css\">
"
      )

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive nil
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil
             :with-creator nil          ;; Include Emacs and Org versions in footer or not
             :with-toc nil              ;; Include a table of contents or not
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil    	;; Don't include time stamp in file
        )
       (list "org-site:articles"
             :recursive t
             :base-directory "./content/articles"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public/articles"
             :with-author nil
             :with-creator nil          ;; Include Emacs and Org versions in footer or not
             :with-toc nil              ;; Include a table of contents or not
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil    	;; Don't include time stamp in file
        )
       (list "org-site:slides"
             :recursive t
             :base-directory "./content/slides"
             :publishing-function 'org-reveal-publish-to-reveal
             :publishing-directory "./public/slides"
             :html-head nil
        )
       )
)

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
