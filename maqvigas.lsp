(vl-load-com)

(defun c:MAQVIGAS ( / ss i ent ed tipo lay alt txt obj)

  (setq ss (ssget))
  (if (not ss)
    (progn (princ "\nNada selecionado.") (exit))
  )

  ;; Criar estilo ROMANS
  (if (not (tblsearch "STYLE" "ROMANS"))
    (command "-STYLE" "ROMANS" "romans.shx" "0" "1" "0" "N" "N" "N")
  )

  (setq i 0)
  (repeat (sslength ss)

    (setq ent (ssname ss i))
    (setq ed  (entget ent))
    (setq tipo (cdr (assoc 0 ed)))
    (setq lay  (cdr (assoc 8 ed)))

    ;; APAGAR LAYERS
    (if (member lay '("ELE_REF_REF_NOME" "ELE_COT_TEXTOS_ESTRIBOS"))
      (entdel ent)

      (progn

        ;; MOVER ELE_COT_COT_ARM
        (if (= lay "ELE_COT_COT_ARM")
          (progn
            (vla-move
              (vlax-ename->vla-object ent)
              (vlax-3d-point '(0 0 0))
              (vlax-3d-point '(0 -10 0))
            )
            ;; Arredondar valor da cota para múltiplo de 5 mais próximo
            (if (= tipo "MTEXT")
              (progn
                (setq obj (vlax-ename->vla-object ent))
                (setq txt (vla-get-TextString obj))
                (setq pos (vl-string-search ";" txt))
                (if pos
                  (progn
                    (setq prefix (substr txt 1 (1+ pos)))
                    (setq numstr (substr txt (+ pos 2)))
                  )
                  (progn
                    (setq prefix "")
                    (setq numstr txt)
                  )
                )
                (setq val (atof numstr))
                (if (> val 0)
                  (progn
                    (setq rounded (* 5 (fix (+ (/ val 5.0) 0.5))))
                    (vla-put-TextString obj (strcat prefix (itoa (fix rounded))))
                  )
                )
              )
            )
          )
        )

        ;; DIMENSION - altura 10 -> 0.01
        (if (and (= tipo "DIMENSION")
                 (= lay "ELE_COT_COMPRIMENTO_PROJETADO"))
          (progn
            (setq obj (vlax-ename->vla-object ent))
            (if (equal (vla-get-TextHeight obj) 10.0 0.001)
              (vla-put-TextHeight obj 0.01)
            )
          )
        )

        ;; TEXT / MTEXT
        (if (member tipo '("TEXT" "MTEXT"))
          (progn

            ;; ===== TEXTO COMUM =====
            (if (= tipo "TEXT")
              (progn
                ;; Estilo
                (setq ed (subst (cons 7 "ROMANS") (assoc 7 ed) ed))

                ;; Largura
                (if (assoc 41 ed)
                  (setq ed (subst (cons 41 0.95) (assoc 41 ed) ed))
                )

                ;; Altura
                (setq alt (cdr (assoc 40 ed)))
                (cond
                  ((equal alt 13.333 0.001)
                   (setq ed (subst (cons 40 12.5) (assoc 40 ed) ed)))
                  ((equal alt 16.667 0.001)
                   (setq ed (subst (cons 40 18.0) (assoc 40 ed) ed)))
                )

                ;; Texto
                (setq txt (cdr (assoc 1 ed)))
                (setq txt (vl-string-subst "x" "x(" txt))
                (setq txt (vl-string-subst " " ") " txt))
                (setq txt (vl-string-translate "()" "" txt))
                (setq txt (vl-string-subst "N" "eN" txt))
                (setq txt (vl-string-subst " c=" "c=" txt))
                (setq ed (subst (cons 1 txt) (assoc 1 ed) ed))

                ;; Caso especial: remover "ou vista de muros"
                (if (vl-string-search "ou vista de muros" (cdr (assoc 1 ed)))
                  (progn
                    (setq ed (subst (cons 1 "Ver esperas no detalhamento de pilares") (assoc 1 ed) ed))
                    (setq ed (subst (cons 40 12.5) (assoc 40 ed) ed))
                    (if (assoc 62 ed)
                      (setq ed (subst (cons 62 4) (assoc 62 ed) ed))
                      (setq ed (append ed (list (cons 62 4))))
                    )
                  )
                )

                (entmod ed)
              )
            )

            ;; ===== MTEXT =====
            (if (= tipo "MTEXT")
              (progn
                (setq obj (vlax-ename->vla-object ent))
                (vla-put-StyleName obj "ROMANS")
                (vla-put-WidthFactor obj 0.95)

                (setq alt (vla-get-Height obj))
                (cond
                  ((equal alt 13.333 0.001)
                   (vla-put-Height obj 12.5))
                  ((equal alt 16.667 0.001)
                   (vla-put-Height obj 18.0))
                )

                (setq txt (vla-get-TextString obj))
                (setq txt (vl-string-subst "x" "x(" txt))
                (setq txt (vl-string-subst " " ") " txt))
                (setq txt (vl-string-translate "()" "" txt))
                (setq txt (vl-string-subst "N" "eN" txt))
                (setq txt (vl-string-subst " c=" "c=" txt))
                (vla-put-TextString obj txt)

                ;; Caso especial: remover "ou vista de muros"
                (if (vl-string-search "ou vista de muros" (vla-get-TextString obj))
                  (progn
                    (vla-put-TextString obj "Ver esperas no detalhamento de pilares")
                    (vla-put-Height obj 12.5)
                    (vla-put-Color obj 4)
                  )
                )
              )
            )

          )
        )

      )
    )

    (setq i (1+ i))
  )

  (princ "\nMAQVIGAS executado com sucesso.")
  (princ)
)
