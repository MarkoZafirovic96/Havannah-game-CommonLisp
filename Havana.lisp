;;--------------------------------------------------------------------------- FUNKCIJE -----------------------------------------------------------------------

;;---funkcije za konverziju kluca ---

(defun conc (&rest objects)
  (car (list(intern (format nil "~{~a~}" objects)))))

(defun poljeAscii (row column)
  (conc (code-char row) column)
  )
(defun polje (row column)
  (conc (character row) column)
)

;; dele kljuc na slovo i broj
(defun vratiKodZaKljuc(kljuc)
  (char-code (char (string kljuc) 0))
  )

(defun vratiBroj(kljuc)
  (parse-integer (subseq  (string kljuc) 1) :junk-allowed t)
  )


;;----------------------pomocnje funkcije----------------------------------------------------------------------------------------------
(defun presek(l1 l2)
  (cond ((null l1) '() )
  ((null l2) '() )
  ((null (member (car l1) l2)) (presek (cdr l1) l2))
  (t
   (cons (car l1) (presek (cdr l1) l2))
   )
  )
  )

(defun razlika(l1 l2)
  (cond ((null l2) l1 )
  ((null l1) '() )
  ((null (member (car l1) l2)) (cons (car l1) (razlika (cdr l1) l2)))
  (t
   (razlika (cdr l1) l2)
   )
  )
  )


;;---funkcije za nalazenje suseda------

;;vracaju sused u odnosu na cvor
(defun gorelevo(cvor)
  (if (null (assoc (poljeAscii (- (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (- (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 1))
    )
  )
(defun gore(cvor)
  (if (null (assoc (poljeAscii (- (vratiKodZaKljuc cvor) 1)  (vratiBroj cvor) ) STANJE)) 
      '()
    (poljeAscii (- (vratiKodZaKljuc cvor) 1)  (vratiBroj cvor) )
    )
  )
(defun levo(cvor)
  (if (null (assoc (poljeAscii (vratiKodZaKljuc cvor)  (- (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (vratiKodZaKljuc cvor)  (- (vratiBroj cvor) 1))
    )
  )
(defun desno(cvor)
  (if (null (assoc (poljeAscii  (vratiKodZaKljuc cvor) (+ (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii  (vratiKodZaKljuc cvor)  (+ (vratiBroj cvor) 1))
    )
  )
(defun dole(cvor)
  (if (null (assoc (poljeAscii (+ (vratiKodZaKljuc cvor) 1)  (vratiBroj cvor) ) STANJE)) 
      '()
    (poljeAscii (+ (vratiKodZaKljuc cvor) 1)  (vratiBroj cvor) )
    )
  )
(defun doledesno(cvor)
  (if (null (assoc (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor) 1))
    )
  )
;;vracaju sused ako ima vrednost XO u odnosu na cvor
(defun gorexo (cvor xo)
	(if (equalp (cadr(assoc (gore cvor) stanje)) xo ) (gore cvor) '())
)
(defun gorelevoxo (cvor xo)
	(if (equalp (cadr(assoc (gorelevo cvor) stanje)) xo ) (gorelevo cvor) '())
)
(defun levoxo (cvor xo)
	(if (equalp (cadr(assoc (levo cvor) stanje)) xo ) (levo cvor) '())
)
(defun desnoxo (cvor xo)
	(if (equalp (cadr(assoc (desno cvor) stanje)) xo ) (desno cvor) '())
)
(defun dolexo (cvor xo)
	(if (equalp (cadr(assoc (dole cvor) stanje)) xo ) (dole cvor) '())
)
(defun doledesnoxo (cvor xo)
	(if (equalp (cadr(assoc (doledesno cvor) stanje)) xo ) (doledesno cvor) '())
)

;;-------------------------------------

;;---funkcije za formatiranje izlaza---
(defun praznopolje(br k) ;;dodaje prazna polja 
	(setq str (concatenate 'string str " "))
	(if(< br k) (praznopolje (+ 1 br) k)  )
)
(defun broji(br)	;; prvi brojevi
	(setq str (concatenate 'string str (write-to-string br) " "))
	(if(< br n) (broji (+ 1 br)) (setq str (concatenate 'string str "~%")))	
)
(defun vrednosti (br) ;; vrednosti vrsta
	(setq str (concatenate 'string str (string(cadr(assoc (poljeAscii (+ slovo i) br) stanje) )) " " ))
	(if (< br j) (vrednosti (+ 1 br)) (if (< j (-(* 2 n)1)) 
	(setq str (concatenate 'string str (write-to-string (+ 1 j)) "~%"))
	(setq str (concatenate 'string str " ~%"))
	))
)
(defun formirajvrednost(br k) ;;sve zajedno
	(setq str (concatenate 'string str (string (code-char (+ slovo i)))))
	(praznopolje 0 (- n br))
	(vrednosti k)
	(setq i (+ 1 i))
	(povecj)
	(cond 
		((< i n)(formirajvrednost (+ 1 br) 1))		
		((>= i (- (* 2 n) 1))	(setq str (concatenate 'string str "")))
		(t (formirajvrednost (- br 1) (+ (- i n) 2)))
	)
)
(defun povecj ()
	(if (< j (-(* 2 n)1)) (setq j (+ 1 j)))
)

(defun formiraj ()	
	(praznopolje 0  n )
	(broji 1)
	(formirajvrednost 1 1)
	
)


(defun iscrtaj()
  (formiraj)
  (format t str)
  
  (setq i '0) ;;reset za sledece crtanje 
  (setq j n) 
  (setq slovo '65) 
  (setq str "~%") 
 
	
)
;--------------------------------------------




(defun napraviTabelu (n vrsta pocetnoSlovo)
  (cond((= vrsta (* '2 n)) '() )
        (
         (> n (- (char-code (character pocetnoSlovo))  '65))
         (append 
          (
           napraviVrstu pocetnoSlovo 1 (+ n (- (char-code (character pocetnoSlovo))  '65 ))
          )
         
          (
           napraviTabelu n (+ vrsta 1) (code-char (+ 1 (char-code (character pocetnoSlovo))))
          )
         )
         )
        (t
         (
          
           append
           (
            napraviVrstu pocetnoSlovo (+ (-(- (char-code (character pocetnoSlovo)) 65) n)2)  (- (* 2 n) (+ (-(- (char-code (character pocetnoSlovo)) 65) n)2))
            
           )
          (
           napraviTabelu n (+ vrsta 1) (code-char (+ 1 (char-code (character pocetnoSlovo))))
           )
          )
         )
        ))

(defun izgenerisiCvorove(n vrsta pocetnoSlovo)
   (cond((= vrsta (* '2 n)) '() )
        (
         (> n (- (char-code (character pocetnoSlovo))  '65))
         (append 
          (
           izgenerisiCvoroveZaVrstu pocetnoSlovo 1 (+ n (- (char-code (character pocetnoSlovo))  '65 ))
          )
         
          (
           izgenerisiCvorove n (+ vrsta 1) (code-char (+ 1 (char-code (character pocetnoSlovo))))
          )
         )
         )
        (t
         (
          
           append
           (
            izgenerisiCvoroveZaVrstu pocetnoSlovo (+ (-(- (char-code (character pocetnoSlovo)) 65) n)2)  (- (* 2 n) (+ (-(- (char-code (character pocetnoSlovo)) 65) n)2))
            
           )
          (
           izgenerisiCvorove n (+ vrsta 1) (code-char (+ 1 (char-code (character pocetnoSlovo))))
           )
          )
         )
        )
  )

(defun izgenerisiCvoroveZaVrstu(slovo poceniIndeks ponavljanja)
  (cond((= ponavljanja 0) '())
        (t
         (append  (list(polje slovo poceniIndeks)) (izgenerisiCvoroveZaVrstu slovo (+ 1 poceniIndeks) (- ponavljanja 1)))
         )
        ))



(defun vratiStranice (dimenzija stranice)
  (let*
      (
       (stranice1 (append stranice (list (gornjaStranica dimenzija))))
       (stranice2 (append stranice1 (list (gornjaLevaStranica dimenzija))))
       (stranice3 (append stranice2 (list (gornjaDesnaStranica dimenzija))))
       (stranice4 (append stranice3 (list (donjaLevaStranica dimenzija))))
       (stranice5 (append stranice4 (list (donjaStranica dimenzija))))
       (stranice6 (append stranice5 (list (donjaDesnaStranica dimenzija))))
    )
  stranice6
  )
  )

(defun gornjaStranica(dimenzija)
  (cond ((= dimenzija 2) '())
        (t
         (append (gornjaStranica (- dimenzija 1)) (list (poljeAscii 65 (- dimenzija 1))))
         )
        )
  )

(defun donjaStranica(dimenzija)
 (cond ((= dimenzija (- (* n 2) 2)) '())
        (t
         (append  (list (poljeAscii (+ 65 (- (* 2 n) 2)) (+ dimenzija 1))) (donjaStranica (+ dimenzija 1)) )
         )
        )
  )

(defun gornjaLevaStranica(dimenzija)
  (cond ((= 2 dimenzija) '())
        (t
         (append (list (poljeAscii (+ 66 (- n dimenzija) ) 1 )) (gornjaLevaStranica (- dimenzija 1)) )
         )
        )
  )

(defun donjaLevaStranica(dimenzija)
  (cond ((= dimenzija 2) '())
        (t
         (append (list (poljeAscii (+ 65 n (- n dimenzija)) (+ (- n dimenzija) 2) )) (donjaLevaStranica (- dimenzija 1)) )
         )
   )
  )

(defun donjaDesnaStranica(dimenzija)
  (cond ((= dimenzija 2) '())
        (t
         (append (list (poljeAscii (+ 65 n (- n dimenzija)) (- (* 2 n) 1) )) (donjaDesnaStranica (- dimenzija 1)))
         )
   )
  )

(defun gornjaDesnaStranica(dimenzija)
   (cond ((= 2 dimenzija) '())
        (t
         (append (list (poljeAscii (+ 66 (- n dimenzija) ) (- (+ n n 1) dimenzija)) ) (gornjaDesnaStranica (- dimenzija 1)) )
         )
        )
  )

(defun vratiTemena(dimenzija)
  (list (poljeAscii 65 1)
        (poljeAscii 65 dimenzija)
        (poljeAscii (+ 64 dimenzija) 1)
        (poljeAscii (+ 64 dimenzija) (- (* 2 dimenzija) 1))
        (poljeAscii (- (+ 65 dimenzija dimenzija) 2) dimenzija)
        (poljeAscii (- (+ 65 dimenzija dimenzija) 2) (- (* 2 dimenzija) 1))
   )
  )

(defun organizujGraf(listaCvorova)
  (cond ((null listaCvorova) '())
        (t
         (append (list (list (car listaCvorova) (dodajPotomke (car listaCvorova) '()))) (organizujGraf (cdr listaCvorova)))
         )
        )
  )

(defun dodajPotomke(cvor lista)
  (let*
      (
       (lista1 (if (not (listp (doledesno cvor))) (append (list (doledesno cvor)) lista) (append (doledesno cvor) lista)))
       (lista2 (if (not (listp (dole cvor))) (append (list (dole cvor)) lista1) (append (dole cvor) lista1)))
       (lista3 (if (not (listp (desno cvor))) (append (list (desno cvor)) lista2) (append (desno cvor) lista2)))
       (lista4 (if (not (listp (levo cvor))) (append (list (levo cvor)) lista3) (append (levo cvor) lista3)))
       (lista5 (if (not (listp (gore cvor))) (append (list (gore cvor)) lista4) (append (gore cvor) lista4)))
       (lista6 (if (not (listp (gorelevo cvor))) (append (list (gorelevo cvor)) lista5) (append (gorelevo cvor) lista5)))
    )
  lista6
    ))

(defun dodajPotomkeXO(cvor X)
  (cvoroviXO (dodajPotomke cvor '()) X)
  )


(defun cvoroviXO(lista XO)
  (cond ((null lista) '())
        ((equalp (cdr (assoc (car lista) stanje)) (list XO)) (append (list (car lista)) (cvoroviXO (cdr lista) XO)) )
        (t
         (cvoroviXO (cdr lista) XO)
         )
        )
  )



(defun vratiCrticu(crtica)
  (if (equal crtica '-) crtica
    '())
  
  )


(defun napraviVrstu (slovo poceniIndeks ponavljanja)
  (cond((= ponavljanja 0) '())
        (t
         (append  (list(list(polje slovo poceniIndeks) (vratiCrticu '-))) (napraviVrstu slovo (+ 1 poceniIndeks) (- ponavljanja 1)))
         )
        ))

(defun inicijalizacija()
  (setq i '0) 
  (setq slovo '65) 
  (setq str "~%")
  (setq da 'da)
  (setq ne 'ne)
  (setq greska '())
  (setq pobeda '())
  (setq koIgra '())
)
(defun dosloDoGreske ()
	greska
)



(defun izaberiProtivnika();; bira se da li se gra protiv racunara ili se igra 1 na 1
	(format t "Da li zelite da igrate protiv racunara?(da/ne)~%")
	(setq protivnikRac (read))
	(cond ((equalp protivnikRac da) (setq protivnik 't)) ;; protivnik je t ako igra protiv  racunara
		  ((equalp protivnikRac ne) (setq protivnik '()))
          (t
           (izaberiProtivnika)
           )
          )
)  
(defun vratiProtivnika () 
protivnik)

(defun izaberiKoPrviIgra()
  (format t "Da li zelite da igrate prvi?(da/ne)~%")
  (setq igrasPrvi (read))
  (cond ((equalp igrasPrvi da) (setq prvoIgraCovek 't))
        ((equalp igrasPrvi ne) (setq prvoIgraCovek '()))
        (t
         (izaberiKoPrviIgra)
         )
        )
  )
(defun prviIliDrugi()
	koIgra
)
(defun koJeNaPotezu()
  (setq naPotezuCovek (prvoIgraCovek))
  )
(defun prvoIgraCovek()
  prvoIgraCovek)

(defun naPotezuCovek()
  naPotezuCovek
  )
;;-----------------------------------------------POTEZI-------------------------------------------------------------------------------------
(defun odigrajPotez(vrsta kolona igrac);;igrac x ili o 
;; vraca nill ako nije odigran valjan potez u suprotnom true 
	(if (proveriPotez (polje vrsta kolona)  stanje)
		(zameniPolje (polje vrsta kolona) igrac )'())
	
)
(defun odigrajPotez1(vrstakolona igrac);;igrac x ili o 
;; vraca nill ako nije odigran valjan potez u suprotnom true 
	(if (proveriPotez vrstakolona  stanje)
		(zameniPolje polje vrstakolona igrac )'())
	
)
(defun proveriPotez(key situacija);;vrsta slovo kolona broji (modifikovano->situacija stanje na tabli)
	(if (equalp (cadr(assoc key situacija) ) '-) 't '()  )
)

(defun zameniPolje(key el);;direkno menjanje polja (glavno stanje se menja)
	(setq  stanje (remove (assoc key stanje) stanje) )
	(setq  stanje (cons  (list key el) stanje) )
  )
;; nove stvari 
(defun virtuelniPotez(situacija key igrac);; zove se pre poziva za key (polje vrsta kolona)odigra potez i vrati novo stanje(koje ne predstavlja trenutno stanje)
	(cond
		((null situacija) '())
		((proveriPotez key situacija) 			
			(cons  (list key igrac) 
			(remove (assoc key situacija) situacija))			
		)
		(t '())
	)
  )
  ;; vraca listu sa svim stanjima (listama ) setuje kljuceve 
(defun vratiSvaStanja (situacija igrac)
	(izgenerisiSveMogucePoteze situacija igrac (izgenerisiCvorove n '1 'a ))
)
;;vraca listu sa svim stanjima 
(defun izgenerisiSveMogucePoteze(situacija igrac kljucevi) ;; klucevi = izgenerisi cvorove
  
  (cond 
   
   ((null kljucevi) '())	
   ((virtuelniPotez situacija (car kljucevi) igrac) (append (list (virtuelniPotez situacija (car kljucevi) igrac))
            (izgenerisiSveMogucePoteze situacija igrac (cdr kljucevi))) )
     
   (t       (izgenerisiSveMogucePoteze situacija igrac (cdr kljucevi)))
				
	)
)
(defun odigrajPotezRacunar (xo)
	
	(let* (
			(potez (alfabeta stanje '('() -100 ) '('() 100) 0 2 't '())))
			
		 
		(cond ((null potez) (setq greska't))
		('t 			
			(setq stanje (virtuelniPotez stanje (caar potez) xo))
			(proveriPobedu (caar stanje) xo)
		)
	)
	)
)
	;;---------------------------------------------------------------Funkcije za igru---------------------------------------------------------------------------------------------

(defun proveriPobedu (cvor xo)
	(cond ((or (nadjiPrsten cvor xo) (vila cvor stranice xo) (most cvor temena xo) )	't)
			('t() '())
	
	
	)
	
)


(defun pocniIgru() ;;pokretanje igra protiv racunara
  (cond ((not (null prvoIgraCovek))  
                          (cond ((not (null naPotezuCovek)) 
                          (format t "Covek na potezu: ~%")
                          (setq vrsta (read))
                          (setq kolona (read))
                          (cond 
								((odigrajPotez vrsta kolona 'x) 
								(cond 
									((proveriPobedu (polje vrsta kolona) 'x) 
										(iscrtaj)
										(format t "Covek je pobedio!!! ~%")
										'()
									)
									(t 
										(setq naPotezuCovek '())
										(iscrtaj)
										(pocniIgru))
									)
								)
								                                  
                                (t
                                    (format t "Niste uneli validan potez~%")
                                    (iscrtaj)
                                   (pocniIgru)
                                   )
                                 ))
                        (t        
                        (princ "Racunar na potezu: ~%")
                        (cond
							((odigrajPotezRacunar 'o) 
								(iscrtaj)
								(format t "Racunar je pobedio!!! ~%")
								'()
							)
							((dosloDoGreske)
								(format t "!!!Doslo je do greske!!!~%")
								'()
							)
                            (t
								(setq naPotezuCovek 't)
                                (iscrtaj)
                                (pocniIgru)
                            )) 
                         )
                        ))
  (t
  (cond   
	((not (null naPotezuCovek))       
       (format t "Covek na potezu: ~%")
       (setq vrsta (read))
       (setq kolona (read))
       (cond
		((odigrajPotez vrsta kolona 'o)
			(cond 
				((proveriPobedu (polje vrsta kolona) 'o) 
					(iscrtaj)
					(format t "Covek je pobedio!!! ~%") 
					'()
				)
				(t 
					(setq naPotezuCovek '())
					(iscrtaj)
					(pocniIgru)
				)
			)
		)
        (t
         (format t "Niste uneli validan potez~%")
         (iscrtaj)
         (pocniIgru)
         )
		)
	)
	(t 
        (format t "Racunar na potezu: ~%")
        (cond
			((odigrajPotezRacunar 'x) 
				(iscrtaj)
				(format t "Racunar je pobedio!!! ~%")
				'()
				)
			((dosloDoGreske)
				(format t "!!!Doslo je do greske!!!~%")
				'()
			)
			(t
				(setq naPotezuCovek 't)
				(iscrtaj)
				(pocniIgru)
			)
		) 
    )
   )
  
   )
   )
)

(defun pocniIgruCovek() ;; pokretanje igra za 1 na 1 
  
  (cond ((not (null koIgra) )
      
       (format t "Prvi igrac na potezu: ")
       (setq vrsta (read))
       (setq kolona (read))
       (cond
			((odigrajPotez vrsta kolona 'x) 
				(cond 
					((proveriPobedu (polje vrsta kolona) 'x) 
						(iscrtaj)
						(format t "Prvi igrac je pobedio!!! ~%")
						'()
					)
					(t 
						(setq koIgra '())
						(iscrtaj)
						(pocniIgruCovek))
					)
			)
			(t
				(format t "Niste uneli validan potez~%")
				(iscrtaj)
				(pocniIgruCovek)
			)))
        (t 
         (format t "Drugi igrac na potezu: ~%")
         (setq vrsta (read))
         (setq kolona (read))
         (cond
		 ((odigrajPotez vrsta kolona 'o) 
				(cond 
					((proveriPobedu (polje vrsta kolona) 'o) 
						(iscrtaj)
						(format t "Drugi igrac je pobedio!!! ~%")
						'()
					)
				(t 
					(setq koIgra 't)
					(iscrtaj)
					(pocniIgruCovek))
					)
			)
        (t
         (format t "Niste uneli validan potez~%")
         (iscrtaj)
         (pocniIgruCovek)
         ))
         )
    )
  
   )
        

;;*------------------------------------------------------VILA I MOST----------------------------------------------
;;Funkcija vraca '() ako nema put do ciljnog cvora ili listu cvorova koji vode do ciljnog cvora ako postoji put
(defun nadji-put (graf l cilj cvorovi XO) ;; l je pocetni cvor u listu stavljen, cvorovi je inicijalno prazna lista i XO je 'x ako se trazi po x ili 'o ako se trazu po o
  (cond ((null l) '())
        ((equal (car l) cilj) (list cilj))
        (t (let* (
                  (cvorovi1 (append cvorovi (list (car l))))
                  (potomci1 (novi-cvorovi (dodajPotomkeXO (car l) XO) (append (cdr l) cvorovi1))) ;; Ovde
                  (l1 (append (cdr l) potomci1))
                  (nadjeni-put (nadji-put graf l1 cilj cvorovi1 XO))
                  )
             (cond ((null nadjeni-put) '())
                   ((member (car nadjeni-put) potomci1) (cons (car l) nadjeni-put))
                   (
                    t nadjeni-put
                      )
                   )
             )
           )
        )
  )

(defun mostPom(cvor temena XO)
  (cond ((null temena) '0)
        ( (> (length (nadji-put graf (list cvor) (car temena) '() XO)) 0) (+ 1 (mostPom cvor (cdr temena) XO)) )
        (t
         (+ 0 (mostPom cvor (cdr temena) XO))
         )
        )
  )

(defun most(cvor temena XO) ;; cvor je potez a temena ima u globalnoj promenljivoj temena koja se inicijalizuje kad se setuje dimenzija table
  (if (> (mostPom cvor temena XO)  1) 't
    '()
      )
  )


(defun temenaXO(temena XO)
  (cond ((null temena) '())
        ((equalp (car temena) XO) (append (car temena) (temenaXO (cdr temena) XO)) )
        (t
         (temenaXO (cdr temena) XO)
         )
   )
  )

(defun straniceXO(stranice XO) ;; vraca listu stranica samo sa poljima koji su jednaki XO
  (cond ((null stranice) '())
        (t
         (append (list (temenaXO (car stranice) XO)) (straniceXO (cdr stranice) XO))
         )
   )
  )

(defun vilaPom(cvor stranice XO)
  (cond ((null stranice) '0 )
        ( (putDoStranice cvor (car stranice) XO) (+ (vilaPom cvor (cdr stranice) XO) 1))
        (t
         (+ (vilaPom cvor (cdr stranice) XO) 0)
         )
   )
  )

(defun vila(cvor stranice XO) ;; cvor je ustvari poslednji dodati potez stranice je globalna promenljiva koja se inicijalizuje na pocetku i XO je x ili o
   (if (> (vilaPom cvor stranice XO)  2) 't
    '()
      )
  )

(defun putDoStranice(cvor stranica XO)
  (cond ((null stranica) '())
        (t
         (or (nadji-put graf (list cvor) (car stranica) '() XO) (putDoStranice cvor (cdr stranica) XO))
         )
        )
  )
;;---------------------------------------------------------------------PRSTEN---------------------------------------------------------------------------
  (defun nadjiPrsten (cvor xo)
  (cond
  ((not (equalp (cadr (assoc cvor stanje)) xo)) '())
  ((null 
	(or 
		(if (null(gorexo cvor xo)) '() (nadji-putPrsten (list(gore cvor)) (dole cvor) '() xo (list cvor (gorelevo cvor) (desno cvor))))
		(if (null(gorexo cvor xo)) '() (nadji-putPrsten (list(gore cvor)) (doledesno cvor) '() xo (list cvor (gorelevo cvor) (desno cvor))))
		(if (null(gorexo cvor xo)) '() (nadji-putPrsten (list(gore cvor)) (levo cvor) '() xo (list cvor (gorelevo cvor) (desno cvor))))
		(if (null(gorelevoxo cvor xo)) '() (nadji-putPrsten (list(gorelevo cvor)) (dole cvor) '() xo (list cvor (gore cvor) (levo cvor))))
		(if (null(gorelevoxo cvor xo)) '() (nadji-putPrsten (list(gorelevo cvor)) (doledesno cvor) '() xo (list cvor (gore cvor) (levo cvor))))
		(if (null(gorelevoxo cvor xo)) '() (nadji-putPrsten (list(gorelevo cvor)) (desno cvor) '() xo (list cvor (gore cvor) (levo cvor))))
		(if (null(levoxo cvor xo)) '() (nadji-putPrsten (list(levo cvor)) (doledesno cvor) '() xo (list cvor (gorelevo cvor) (dole cvor))))
		(if (null(levoxo cvor xo)) '() (nadji-putPrsten (list(levo cvor)) (desno cvor)'() xo (list cvor (gorelevo cvor) (dole cvor))))
		(if (null(desnoxo cvor xo)) '() (nadji-putPrsten (list(desno cvor)) (dole cvor) '() xo (list cvor (gore cvor) (doledesno cvor))))
		)
   )				
   '())
     (t 't)

 )
)
(defun nadji-putPrsten (l cilj cvorovi XO zabranjeni) ;; l je pocetni cvor u listu stavljen, cvorovi je inicijalno prazna lista i XO je 'x ako se trazi po x ili 'o ako se trazu po o
  (cond ((null l) '())
	
        ((equal (car l) cilj) (list cilj))
        (t (let* (
                  (cvorovi1 (append cvorovi (list (car l))))
                  (potomci1 (novi-cvorovi (razlika (dodajPotomkeXO (car l) XO) zabranjeni) (append (cdr l) cvorovi1))) ;; Ovde
                  (l1 (append (cdr l) potomci1))
                  (nadjeni-put (nadji-putPrsten l1 cilj cvorovi1 XO zabranjeni))
                  )
             (cond ((null nadjeni-put) '())
                   ((member (car nadjeni-put) potomci1) (cons (car l) nadjeni-put))
                   (
                    t nadjeni-put
                      )
                   )
             )
           )
        )
  )






(defun novi-cvorovi (potomci cvorovi)
  (cond ((null potomci) '())
        ((member (car potomci) cvorovi)
         (novi-cvorovi (cdr potomci) cvorovi))
        (t 
         (cons (car potomci) (novi-cvorovi (cdr potomci) cvorovi))
         )
        )
  )
  
  
  
;;----------------------------------------------------------------------------ALFA BETA-------------------------------------------------------------------------------  
  
  (defun setujVrednosti(dimenzija lista pocetnoSlovo)
	(setq vrednostiPolja (dodeliVrednosti (izgenerisiCvorove dimenzija lista pocetnoSlovo)))
	(setq vrednostiPoljaTest vrednostiPolja )
  )
  
  (defun dodeliVrednosti(lista)
	(cond ((null lista) '())
	((member (car lista) TEMENA) (append (list (list (car lista) '10)) (dodeliVrednosti (cdr lista))))
	((member (car lista) (cvoroviZaStranice STRANICE)) (append (list (list (car lista) '3)) (dodeliVrednosti (cdr lista))))
	
	(t
		(append (list (list (car lista) '0)) (dodeliVrednosti (cdr lista)))
	)
  )
  )
  (defun cvoroviZaStranice(lista)
	(cond ((null lista) '())
	(t
		(append (car lista) (cvoroviZaStranice (cdr lista)))
	)
	)
  )
  
  
	(defun stanjeVrednosti(listaStanja lista) ;; listu stanja i listu vrednosti spaja u asocijativnu listu stanje vrednost
		(cond ((null listaStanja) '() )
			(t
				(append (list (list (car listaStanja) (cadr (assoc (car lista) vrednostiPolja)))) (stanjeVrednosti (cdr listaStanja) (cdr lista)) )
			)
		)
	)
	
	(defun vratiMogucePoteze(stanje) ;;vraca sve neodigrane poteze na osnovu stanja
		(cond ((null stanje) '())
			((equalp (cadar stanje) '-) (append (list (caar stanje)) (vratiMogucePoteze (cdr stanje))))
		(t
			 (vratiMogucePoteze (cdr stanje))
		)
		)
		)
	(defun stanjeVrednostXO(XO) ;; Na osnovu toga koji je igrac na potezu vrati asocijativnu listu mogucih stanja i vrednosti 
		(stanjeVrednosti (vratiSvaStanja stanje XO) (vratiMogucePoteze stanje) )
	)
	
	(defun proceniStanje(stanje vrednosti) ;; Vrsi procenu stanja na osnovu trenutnog stanja tj poziva funkciju proceniStanjePom i ako je min igrac setuje vrednosti na negativne vrednosti
		
			;;(proceniStanjePom stanje)
			
			(setq vrednostiPolja(promeniVrednostiNegativne vrednosti))
			;;)
			(vratiMoguceVrednosti (vratiMogucePoteze stanje ) )
			
	)
	(defun vratiMoguceVrednosti(lista)
		(cond ((null lista) '())
				(t (append (list(list (car lista) (cadr(assoc (car lista) vrednostiPolja))))  (vratiMoguceVrednosti (cdr lista))  )
		)
	)
	)
	(defun proceniStanjePom(stanje) ;; Ova funkcija treba da vrsi stvarnu procenu stanja na osnovu trenutnog stanja odnosno da menja globalnu promenljivu vrednostiPolja 
		
	)
	
	(defun promeniVrednostiNegativne(vrednosti)
		(cond ((null vrednosti) '())
		(t
			(append (list (list (caar vrednosti) (* -1 (cadar vrednosti)))) (promeniVrednostiNegativne (cdr vrednosti)))
		)
		)
	)
	
	(defun minimum (list)  ;;trazi minimum iz asocijativne liste i vraca listu kljuc vrednost

		(cond

       ((null list)                      
        nil)

       ((null (cdr list))              
        (car list))

       ((< (cadar list) (cadadr list))   
        (minimum (cons (car list)      
                       (cdr (cdr list)))))

       (t                               
        (minimum (cdr list)))))
	
	(defun maximum (list) ;; trazi maximum iz asocijativne liste i vraca listu kljuc vrednost

		(cond

       ((null list)                      
        nil)

       ((null (cdr list))              
        (car list))

       ((> (cadar list) (cadadr list))   
        (maximum (cons (car list)      
                       (cdr (cdr list)))))

       (t                               
        (maximum (cdr list)))))
	
	(defun alfaBetaSledbenici(sledbenici alfa beta dubina maxDubina mojPotez kompX) ;; za sve sledbenike prethodnog stanja poziva funkciju alfabeta stavlja rezultat u listu i vraca tu listu
		(cond ((null sledbenici) '())
			(t
				
				(append (alfabeta (caar sledbenici) alfa beta dubina maxDubina mojPotez kompX) (alfaBetaSledbenici (cdr sledbenici) alfa beta dubina maxDubina mojPotez kompX))
			)
		)
	)

	
	
	(defun alfabeta(stanje alfa beta dubina maxDubina mojPotez kompX) ;;vraca listu stanje vrednost
		(cond ( (or (= dubina maxDubina) (null (stanjeVrednostXO 'x)) ) ;;nema vise poteza ili se doslo do maxDubine
					(proceniStanje stanje vrednostiPolja)
					
				)
				(t
					(let*
						(
							
							(listaPoteza (cond ( mojPotez (if kompX (stanjeVrednostXO 'x) (stanjeVrednostXO 'o)))
							(t (if kompX (stanjeVrednostXO 'o) (stanjeVrednostXO 'x)))))
							(alfa1 (if mojPotez (maximum (append (list alfa) (alfaBetaSledbenici listaPoteza alfa beta (1+ dubina) maxDubina (not mojPotez) kompX))) alfa))
							(beta1 (if mojPotez beta (minimum (append (list beta) (alfaBetaSledbenici listaPoteza alfa beta (1+ dubina) maxDubina (not mojPotez) kompX)))))
						)
						
						(if mojPotez (if (>= (cadr alfa1) (cadr beta1)) (list beta1) (list alfa1) )
							(if (>= (cadr alfa1) (cadr beta1)) (list alfa1) (list beta1)
							)
						)
					)
				)
		)
		
	)
	
	
	
	

	
;;------------------------heuristika---------

;; ovo samo vraca vcvor za cvor u zavisnosti od pozicije
(defun virtualniGore(cvor)
  (if (null (assoc (poljeAscii (- (vratiKodZaKljuc cvor) 2) (- (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (- (vratiKodZaKljuc cvor) 2) (- (vratiBroj cvor) 1))
    )
  )

(defun virtualniGoreDesno(cvor)
  (if (null (assoc (poljeAscii (- (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (- (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor) 1))
    )
  )
(defun virtualniGoreLevo(cvor)
  (if (null (assoc (poljeAscii (- (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 2)) STANJE)) 
      '()
    (poljeAscii (- (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 2))
    )
  )
(defun virtualniDoleDesno(cvor)
  (if (null (assoc (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor)2)) STANJE)) 
      '()
    (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (+ (vratiBroj cvor) 2))
    )
  )  
(defun virtualniDole(cvor)
  (if (null (assoc (poljeAscii (+ (vratiKodZaKljuc cvor) 2) (+ (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (+ (vratiKodZaKljuc cvor) 2) (+ (vratiBroj cvor) 1))
    )
   )
(defun virtualniDoleLevo(cvor)
  (if (null (assoc (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 1)) STANJE)) 
      '()
    (poljeAscii (+ (vratiKodZaKljuc cvor) 1) (- (vratiBroj cvor) 1))
    )
  )
(defun evaluacija(situacija xo )
	vrednostiPoljaTest 
	
)
(defun zajednickiSusediXO (cvor1 cvor2 xo)
	(presek (dodajPotomkexo cvor1 xo) (dodajPotomkexo cvor2 xo))
	
)
(defun zajednickiSusedi (cvor1 cvor2 ) ;; susedi za 2 cvora koristi se kod virtualnih cvorova 
	(presek (dodajPotomke cvor1 '()) (dodajPotomke cvor2 '()))
	
)

(defun vratiOdigranePotezeXO(situacija xo);;vraca odigrane poteze za XO
	(cond ((null situacija) '())
		((equal (cadar situacija) xo)  (append (list(caar situacija)) (vratiOdigranePotezeXO (cdr situacija ) xo)))
		('t (vratiOdigranePotezeXO (cdr situacija  )xo))
	
	)
)

(defun dodajVirtualne(cvor lista) ;; vraca virtuelne cvorove cvora 
  (let*
      (
       (lista1 (if (not (listp (virtualniGore cvor))) (append (list (virtualniGore cvor)) lista) (append (virtualniGore cvor) lista)))
       (lista2 (if (not (listp (virtualniGoreDesno cvor))) (append (list (virtualniGoreDesno cvor)) lista1) (append (virtualniGoreDesno cvor) lista1)))
       (lista3 (if (not (listp (virtualniGoreLevo cvor))) (append (list (virtualniGoreLevo cvor)) lista2) (append (virtualniGoreLevo cvor) lista2)))
       (lista4 (if (not (listp (virtualniDoleDesno cvor))) (append (list (virtualniDoleDesno cvor)) lista3) (append (virtualniDoleDesno cvor) lista3)))
       (lista5 (if (not (listp (virtualniDole cvor))) (append (list (virtualniDole cvor)) lista4) (append (virtualniDole cvor) lista4)))
       (lista6 (if (not (listp (virtualniDoleLevo cvor))) (append (list (virtualniDoleLevo cvor)) lista5) (append (virtualniDoleLevo cvor) lista5)))
    )
  lista6
    ))
(defun virtuelniCvorovi (cvor xo) ;; vraca virtualne cvorove cvora za vrednost XO
	(let* (
		(clist (cvoroviXO (dodajVirtualne cvor '()) xo))
		(vlist (odrediVirtuelne cvor clist '- ))	
	)
	vlist
	)
)
(defun virtuelniCvoroviSamoCvor (cvor) ;; vraca virtualne cvorove bez xo
	(let* (
		(clist (dodajVirtualne cvor '()))
		(vlist (odrediVirtuelne cvor clist '- ))	
	)
	vlist
	)
)
(defun odrediVirtuelne (cvor lista xo);;pomocna fja za ovo gore
	(cond 
		((null lista ) '())
		((equal (length (cvoroviXO (zajednickiSusedi cvor (car lista)) xo)) 2) 
			 (append (list (car lista)) (odrediVirtuelne cvor (cdr lista) xo)))
		('t (odrediVirtuelne cvor (cdr lista ) xo))
	)
)



(defun vratiTemenaXO (dimenzija xo);; temena koja imaju XO 
	(cvoroviXO (vratiTemena dimenzija) xo)

)

;; nalazi vmost za date cvorove i cilj obicno trazenje od temena do temena pomocna fja ga lepo pravi valjda :D
(defun nadjiVirtuelniMost (l cilj cvorovi XO) ;; l je pocetni cvor u listu stavljen, cvorovi je inicijalno prazna lista i XO je 'x ako se trazi po x ili 'o ako se trazu po o
  (cond ((null l) '())
	
        ((equal (car l) cilj) (list cilj))
        (t (let* (
                  (cvorovi1 (append cvorovi (list (car l))))
                  (potomci1 (novi-cvorovi (append (dodajPotomkeXO (car l) XO) (virtuelniCvorovi (car l) XO)) (append (cdr l) cvorovi1))) ;; Ovde
                  (l1 (append  potomci1 (cdr l)))
                  (nadjeni-put (nadjiVirtuelniMost l1 cilj cvorovi1 XO ))
                  )
             (cond ((null nadjeni-put) '())
                   ((member (car nadjeni-put) potomci1) (cons (car l) nadjeni-put))
                   (
                    t nadjeni-put
                      )
                   )
             )
           )
        )
  )

(defun postojiVirtuelniMost(lista xo);; vraca Virtuelni most ako postoji!
	(cond 
		((null lista) '())
		('t 
			(let*
				(
					(nadjenput (JedanVirtuelniMost (car lista) (cdr lista) xo))
				)
				(if nadjenput nadjenput 
					(postojiVirtuelniMost (cdr lista) xo) )
				
			)
		) 
	
	)
)
(defun JedanVirtuelniMost(cvor cilj xo);;pomocna sa virtuelniMost
	(cond ((null cilj ) '())
	('t	
		(let* (
			(nadjenput 	(nadjiVirtuelniMost (list cvor) (car cilj) '() xo) )
		)
		(if nadjenput nadjenput (JedanVirtuelniMost cvor (cdr cilj) xo) )
		)
	
	)
	)
)
(defun promeniXO (xo) 	;; menja X u O i O u X
	(cond ((equal xo 'x) 'o)
		((equal xo 'o) 'x)
		('t '())
)
)

;;promeni vrednosti za cvorove na jedno 50 
;;treba se DODA Za virtuealne vile i da se doda 
(defun heruristika (situacija xo) ;; glavna fja 
	(let*
			(	
				(odigrani (vratiOdigranePotezeXO situacija xo))				
				(pobedaM (proveriMost (razlika odigrani temena) XO))
				(pobedaV (proveriVilu (razlika odigrani stranice) XO))
				(pobedaP (proveriPrsten odigrani XO))
				(temenai (vratiTemenaXO n xo))
				
				(poteziStanje (vratiOdigranePotezeXO stanje xo))
				
				
				(odigranip (vratiOdigranePotezeXO situacija (promeniXO XO)))	
				(pobedaMP (proveriMost (razlika odigrani temena) (promeniXO XO)))
				(pobedaVP (proveriVilu (razlika odigrani stranice) (promeniXO XO)))
				(pobedaPP (proveriPrsten odigrani (promeniXO XO)))
				
				(vputM (postojiVirtuelniMost temenai xo))
				;; (vputV (postojiVirtuelnaVila )treba se napravi 
				
			)
			;;gleda se stanje u koje je dosao preko minmax i ako to stanje ima pobedu igra se to stanje tj. igraju se potezi tog stanja vazi samo za pobedu
			;; za virutalno gleda se glavno stanje ono u promenljivu zato svakao se igra ka virutelnom stanju posle jedino sto mozda nije najbolje optimizovano normalno igranje 
			;; jer mogu da se igraju potezi koji zaobilaze kroz nekolko poteza cilj jer je uvek ista brojka ova od 200 !!!!!!! to mozda moze da se optimizuje da se igra ka ivici 
			;; nekako da ga stavimo da se ili povecava ili nesto da ivica ima vecu vrednost od centra ne znam vidi ako smislis nesto stavi
			(cond	
				((equal xo 'x);;ovde je mozda greska treba da ide dubina a ne xo ili tako ono true false za potez nisam bio siguran pa sam stavio ovo promeni ga ako baca gresku 																																	
					;;moguca izmena da se umesto direknih vrednosti dodaju vrednosti na prom vrednostuPolja ali mislim da i ovo radi mora ga testiras 
					(cond 
						((not (null pobedaM)) (vrednostiCvorovaList (razlika pobedaM poteziStanje)1000) );;ako ima pobedu u zadatom stanju igra potez sa tog stanja koje nema na glavnom stanju 
						((not (null pobedaV)) (vrednostiCvorovaList (razlika pobedaV poteziStanje) 1000) );;isto za vilu
						((not (null pobedaP)) (vrednostiCvorovaList (razlika pobedaP poteziStanje) 1000) );;isto za prsten
						((not (null pobedaMP)) (vrednostiCvorovaList (razlika pobedaMP poteziStanje) 500) );; ako protivnik ima pobedu igra odbranu po redu 
						((not (null pobedaVP)) (vrednostiCvorovaList (razlika pobedaVP poteziStanje) 500) )
						((not (null pobedaPP)) (vrednostiCvorovaList (razlika pobedaPP poteziStanje) 500) )
						((not (null vputM)) (vrednostiCvorovaList (vratiPotezeZaVMost vputM) 300) );;ovo ako postoji vmost na glavnom stanju igra poteze za spajanje mosta 
						;;treba stoji ovde za virtuelnu vilu ako postoji da se igraju potezi za zatvaranje vile 
						;;inace mislim da prvo treba da se igra Most ako postoji virtelni Most zato sto je brzi 
						((equal (length poteziStanje) 3)		;; ovo gleda glavno stanje da vidi dal je odigrano prva 3 poteza koja su coske pa onda radi ono za virtualne cvorove
							(vrednostiCvorovaList (sviVirtuelniZaStanje poteziStanje) 200) );;valjda radi 
					
						('t 	(vratiMoguceVrednosti (vratiMogucePoteze stanje ) )) ;;ovo je ono basic ako nema nista tj/ ako nema nista igra se po vrednosti 
					)
				)
				('t 
						(cond 
						((not (null pobedaM)) (vrednostiCvorovaList (razlika pobedaM poteziStanje) -1000) ) ;; sve isto kao i prethodno samo sto je ovo sa - za rotaciju izmedju igraca 
						((not (null pobedaV)) (vrednostiCvorovaList (razlika pobedaV poteziStanje) -1000) )
						((not (null pobedaP)) (vrednostiCvorovaList (razlika pobedaP poteziStanje) -1000) )
						((not (null pobedaMP)) (vrednostiCvorovaList (razlika pobedaMP poteziStanje) -500) )
						((not (null pobedaVP)) (vrednostiCvorovaList (razlika pobedaVP poteziStanje) -500) )
						((not (null pobedaPP))(vrednostiCvorovaList (razlika pobedaPP poteziStanje) -500) )
						((not (null vputM)) (vrednostiCvorovaList (vratiPotezeZaVMost vputM) -300) )
							;;treba stoji ovde za virtuelnu vilu
						((equal (length poteziStanje) 3)		;; ovo gleda glavno stanje da vidi dal je odigrano prva 3 poteza koja su coske pa onda radi ono za virtualne cvorove
							(vrednostiCvorovaList (sviVirtuelniZaStanje poteziStanje) -200) );;valjda radi 
							
						('t 	(vratiMoguceVrednosti (vratiMogucePoteze stanje ) ));;basic samo je u plus nije u minsu to se treba promeni 
					)
				)
			)
		)

)

(defun sviVirtuelniZaStanje (lista)
	(cond ((null lista) '())
		('t 
			(append (virtuelniCvoroviSamoCvor (car lista )) (sviVirtuelniZaStanje (cdr lista))))
	
	
	)

)
(defun vratiPotezeZaVMost (lista)  ;;vraca virtualne susede koji trebaju da se popune kada postoji virtuelni put koji je predstavlje listom list pr. lista = (a1 a2 b4 a5 a6 )
	(cond ((null lista ) '())		;; mislim da moze da sluzi i za virtuelnu vilu ako ce koristis 
		((null (cadr lista)) '())
		((member (cadr lista) (dodajPotomke (car lista) '()))
			(vratiPotezeZaVMost (cdr lista))
		)
		((member (cadr lista) (dodajVirtualne (car lista) '()))
			(append (zajednickiSusedi (car lista ) (cadr lista)) (vratiPotezeZaVMost (cdr lista)))
		)
		('t 
			(vratiPotezeZaVMost (cdr lista)))
	
	)
	
)

(defun vrednostiCvorovaList(cvorovi vrednost) ;; cvorovi = lista svih cvorova a vrednost je brojka koja vrednuje polje ako ima vise cvora sa istom vrednosti
	(cond ((null cvorovi) '())				;; pravi listu svih parova (cvor vrednost) ,, rezultat = ((a1 100) (a2 100 )) itd. pravi zato sto alfabeta koristi takve vrednosti
			('t 
				(append (list(list (car cvorovi) vrednost))(vrednostiCvorovaList (cdr cvorovi) vrednost))
			)
	
	)

)
  
 (defun proveriMost (lista xo);;proverava da li postoji most i ako postoji vraca listu cvorova tog mosta 
	(cond ((null lista) '())
		
		('t  
			(let*(
					(ima (most (car lista) temena xo) )
				)
				(if ima ima (proveriMost (cdr lista) xo))				
			)
		)	
	)
 )
  (defun proveriVilu (lista xo);;isto ko i pretodno samo za vilu
	(cond ((null lista) '())
		
		('t  
			(let*(
					(ima (vila (car lista) stranice xo) )
				)
				(if ima ima (proveriVilu (cdr lista) xo))				
			)
		)	
	)
 )
  (defun proveriPrsten (lista xo);; isto ko prethodno samo za prsten
	(cond ((null lista) '())
		
		('t  
			(let*(
					(ima (nadjiPrsten (car lista) xo) )
				)
				(if ima ima (proveriPrsten (cdr lista) xo))				
			)
		)	
	)
 )
 
 
 ;;----------------------------------------------VirtualnaVila----------------------------------

(defun drugiRedGore()
	(drugiRedGorePom (cdr (gornjaStranica n)) )
)

(defun drugiRedGorePom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (dole (car stranica)) (drugiRedGorePom (cdr stranica)))
	)
	)
)

(defun drugiRedGoreLevo()
	(drugiRedGoreLevoPom (cdr (gornjaLevaStranica n)))
)

(defun drugiRedGoreLevoPom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (desno (car stranica)) (drugiRedGoreLevoPom (cdr stranica)))
	)
	)
)

(defun drugiRedGoreDesno()
	(drugiRedGoreDesnoPom (cdr (gornjaDesnaStranica n)))
)

(defun drugiRedGoreDesnoPom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (levo (car stranica)) (drugiRedGoreDesnoPom (cdr stranica)))
	)
	)
)

(defun drugiRedDoleDesno()
	(drugiRedDoleDesnoPom (cdr (donjaDesnaStranica n)))
)

(defun drugiRedDoleDesnoPom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (gorelevo (car stranica)) (drugiRedDoleDesnoPom (cdr stranica)))
	)
	)
)

(defun drugiRedDoleLevo()
	(drugiRedDoleLevoPom (cdr (donjaLevaStranica n)))
)

(defun drugiRedDoleLevoPom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (gore (car stranica)) (drugiRedDoleLevoPom (cdr stranica)))
	)
	)
)

(defun drugiRedDole ()
	(drugiRedDolePom (cdr (donjaStranica n)))
)

(defun drugiRedDolePom(stranica)
	(cond ((null stranica) '())
	(t
		(cons (gorelevo (car stranica)) (drugiRedDolePom (cdr stranica)))
	)
	)
)

(defun drugiRedSvakeStranice()
	(let*
      (
       (stranice1 (list (reverse (drugiRedDoleDesno)))  )
       (stranice2 (append stranice1 (list (drugiRedDole))))
       (stranice3 (append stranice2 (list (drugiRedDoleLevo))))
       (stranice4 (append stranice3 (list (drugiRedGoreLevo))))
       (stranice5 (append stranice4 (list (reverse (drugiRedGore )))))
       (stranice6 (append stranice5 (list (reverse (drugiRedGoreDesno) ))))
    )
  stranice6
  )
)

(defun drugiRedSvakeStraniceXO(XO)
	(drugiRedSvakeStranicePomXO (drugiRedSvakeStranice ) XO)
)	

(defun drugiRedSvakeStranicePomXO (str XO)
	(cond ((null str) '())
	
		(t 
			(if (not (equalp (samoXO (car str) XO) '()))
				(append  (list (samoXO (car str) XO)) (drugiRedSvakeStranicePomXO (cdr str) XO) )
				(drugiRedSvakeStranicePomXO (cdr str) XO)
			)
		)
	)
)

(defun samoXO(lista XO)
	(cond ((null lista) '() )
	((equalp (cadr (assoc (car lista) stanje) ) XO) (append (list (car lista)) (samoXO (cdr lista) XO)))
		(t
			(samoXO (cdr lista) XO)
		)
	)
)

(defun dodajVirtualneBezTemenaIStranice(cvor lista) ;; vraca virtuelne cvorove cvora 
  (let*
      (
       (lista1 (dodajVirtualne cvor lista))
       (lista2 (razlika lista1 temena))
       (lista3 (razlika lista2 (car stranice)))
       (lista4 (razlika lista3 (cadr stranice)))
       (lista5 (razlika lista4 (caddr stranice)))
       (lista6 (razlika lista5 (cadddr stranice)))
	   (lista7 (razlika lista6 (car (reverse stranice))))
	   (lista8 (razlika lista7 (cadr (reverse stranice))))
    )
  lista8
    )
)

(defun nadjiVirtualniPut (l cilj cvorovi sviPutevi) ;; l je pocetni cvor u listu stavljen, cvorovi je inicijalno prazna lista i XO je 'x ako se trazi po x ili 'o ako se trazu po o
  (cond ((null l) '())
        ((equal (car l) cilj) (list cilj))
        (t 
			(nadjiVirtualniPut (cdr l) cilj cvorovi sviPutevi)
			
			(let* 
				  (
				  (cvorovi1 (append cvorovi (list (car l))))
				  (potomci1 (novi-cvorovi (dodajVirtualneBezTemenaIStranice (car l) '()) (append (cdr l) cvorovi1))) ;; Ovde
				  (l1 (append  potomci1 (cdr l)))
				  (nadjeni-put (nadjiVirtualniPut l1 cilj cvorovi1 sviPutevi))
                  )
				 (cond ((null nadjeni-put) '())
					   ((member (car nadjeni-put) potomci1) (cons (car l) nadjeni-put))
					   (t 
						(append (list nadjeni-put) sviPutevi)
						(setq putevi sviPutevi)
						)
					   )
				 )
            )
        )
    )








 
;;----------------------------------------------------------------------------------------------------IGRAJ----------------------------------------------------------------------------------------------
(defun igraj()
  (inicijalizacija)
  (format t "Unesite dimenziju tabele ~%")
  (setq n (read))
  (cond( (not(numberp n))
        (format t "Niste uneli validnu vrednost za dimenziju tabele~%")
        
        (igraj)
        )
        (
         (or (< n 2) (> n 14))
         (format t  "Dimenzija tabele mora biti u opsegu od 3 do 14~%")
         
         (igraj)
         )
        (t 
		 (izaberiProtivnika)
        
         (setq j n)
         (setq stanje (napraviTabelu n 1 'a))
         (setq graf (organizujGraf (izgenerisiCvorove n 1 'a)))
         (setq stranice (vratiStranice n '()))
         (setq temena (vratiTemena n))
		 (setujVrednosti n 1 'a)
        
		 (cond ((vratiProtivnika) (izaberiKoPrviIgra)  (iscrtaj) (koJeNaPotezu) (pocniIgru));;protiv racunara
			   (t (setq koIgra 't )  (iscrtaj) (pocniIgruCovek));; 1 na 1 
		 
		 
		 )
		 
		 
		 
        )
  ))
  
  


;;(igraj)
 
 
 
  

