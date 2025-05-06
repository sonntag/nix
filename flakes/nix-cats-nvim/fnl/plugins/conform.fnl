(local conform (require :conform))

(conform.setup {:formatters_by_ft {:clojure [:cljstyle]
	                           :nix [:alejandra]}
	        :format_on_save {:lsp_fallback true
		                 :async false
				 :timeout_ms 500}})

{}
