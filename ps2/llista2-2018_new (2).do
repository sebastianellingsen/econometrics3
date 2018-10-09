cd "/Users/sebastianellingsen/Desktop/Econometrics lll/llista2list2"

clear all
capture log close
log using llista2.log,replace
use enquesta2009-2018,clear

la def labb 1 "metro " 2 "bus " 3 "tram " 4 "cotxe " 5 "peu " 6 "bici " 7 "moto " 8 "tren "
la val transport labb

sum

* A: descripcio de variables
tab1 edat genere transport distancia universitat carrera curs treballa educa_pare educa_mare

*histogram transport, percent discrete by(year) start(1) addlabels
histogram transport, percent discrete by(year) start(1)  /*
*/ xlabels(1 "metro " 2 "bus " 3 "tram " 4 "cotxe " 5 "peu " 6 "bici " 7 "moto " 8 "tren ", angle(45))
/* graph export transport.pdf,replace */

* generacio de variables
gen upf=univ==1
gen ldistancia=log(distancia)
gen dona=genere==2
replace year=year-2008

* APARTAT B:

tab transport
mlogit transport, baseoutcome(1)
predict p1 p2 p3 p4 p5 p6 p7 p8 /* una variable per cada outcome */
sum p1-p8

*Note: it's common to choose the most frequent outcome as the baseoutcome


*Predict the choices just as a function of a constant, can do better than just guessing the mean with more variables.

* APARTAT C:

mlogit transport edat i.dona i.upf ldistancia year, baseoutcome(1)
estimates store t1

mlogit transport edat i.dona i.upf ldistancia year if transport!=4, baseoutcome(1)
estimates store t1p

hausman t1p t1, constant alleqs


* APARTAT D:

mlogit transport edat i.dona i.upf ldistancia year, baseoutcome(1)
margins, dydx(edat dona upf ldistancia)
tab transport
margins, dydx(ldistancia) pr(out(5))
margins, dydx(ldistancia) pr(out(8))
*Walking and train is very sensitive to distance.

margins, dydx(edat dona upf ldistancia) predict(outcome(2))
margins, dydx(edat dona upf ldistancia) predict(outcome(3))
margins, dydx(edat dona upf ldistancia) predict(outcome(4))
margins, dydx(edat dona upf ldistancia) predict(outcome(5))
margins, dydx(edat dona upf ldistancia) predict(outcome(6))
margins, dydx(edat dona upf ldistancia) predict(outcome(7))
margins, dydx(edat dona upf ldistancia) predict(outcome(8))

mlogit transport edat i.dona i.upf ldistancia i.year, baseoutcome(1)
margins, dydx(*)



*APARTAT E

gen public=transport
recode public 1 2 3 8=1 4 5 6 7 =0
gen medi=transport
recode medi 1 2 3 8=1 4 7=2 5 6=3

logit public edat dona upf ldistancia year
margins, dydx(*)

mlogit medi edat dona upf ldistancia year, baseoutcome(1)
margins, dydx(*)

mlogit transport edat i.dona i.upf ldistancia i.year, baseoutcome(1)
margins, dydx(*)
