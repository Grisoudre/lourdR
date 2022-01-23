
# Fonctions

Le package contient les fonctions :

  - **freqm** : Tris à plat de variables issues de questions à choix
    multiples et pondérables
  - **freqp** : Présentation des fréquences et pourcentages pondérés et
    bruts dans un unique tableau

# Installation

``` r
if (!require("devtools")) install.packages("devtools", dep=T)
devtools::install_github("Grisoudre/lourdR")
```

## Documentation

``` r
?freqm
?freqp
```

# Exemples

## Données

A partir des données extraites de l’enquête “Histoire de vie”, 2003,
Insee, et fournies par le package {questionr} :

``` r
library(lourdR)
data("hdv2003")
# Renommer les variables cibles avec le préfixe "activite_" :
index<-match("hard.rock", names(hdv2003)):match("sport", names(hdv2003))
hdv2003 <- hdv2003 %>% 
  rename_at(index,~paste0("activite_",.))
```

## freqm : Fréquences et pourcentages de données issues de questions à choix multiples

### Fréquences et pourcentages de chacune des variables

``` r
freqm(hdv2003, "activite_")
##                   name calc    Non   Oui Total
##        activite_bricol    %   57.4  42.6   100
##        activite_bricol    n 1147.0 853.0  2000
##        activite_cinema    %   58.7  41.3   100
##        activite_cinema    n 1174.0 826.0  2000
##       activite_cuisine    %   56.0  44.0   100
##       activite_cuisine    n 1119.0 881.0  2000
##     activite_hard.rock    %   99.3   0.7   100
##     activite_hard.rock    n 1986.0  14.0  2000
##    activite_lecture.bd    %   97.7   2.4   100
##    activite_lecture.bd    n 1953.0  47.0  2000
##  activite_peche.chasse    %   88.8  11.2   100
##  activite_peche.chasse    n 1776.0 224.0  2000
##         activite_sport    %   63.8  36.1   100
##         activite_sport    n 1277.0 723.0  2000
```

### En réordonnant les colonnes à l’aide des facteurs

``` r
ordre <- c("Oui","Non")
hdv2003 <- hdv2003 %>% mutate(across(matches("^activite_"), ~factor(., levels = ordre)))
freqm(hdv2003, "activite_")
##                   name calc   Oui    Non Total
##        activite_bricol    %  42.6   57.4   100
##        activite_bricol    n 853.0 1147.0  2000
##        activite_cinema    %  41.3   58.7   100
##        activite_cinema    n 826.0 1174.0  2000
##       activite_cuisine    %  44.0   56.0   100
##       activite_cuisine    n 881.0 1119.0  2000
##     activite_hard.rock    %   0.7   99.3   100
##     activite_hard.rock    n  14.0 1986.0  2000
##    activite_lecture.bd    %   2.4   97.7   100
##    activite_lecture.bd    n  47.0 1953.0  2000
##  activite_peche.chasse    %  11.2   88.8   100
##  activite_peche.chasse    n 224.0 1776.0  2000
##         activite_sport    %  36.1   63.8   100
##         activite_sport    n 723.0 1277.0  2000
```

### En réordonnant les colonnes sans facteurs

``` r
levels <- c("name","calc","Oui","Non","Total")
freqm(hdv2003, "activite_", verbose=F) %>% 
  select(all_of(levels))
##                     name calc   Oui    Non Total
## 1        activite_bricol    %  42.6   57.4   100
## 2        activite_bricol    n 853.0 1147.0  2000
## 3        activite_cinema    %  41.3   58.7   100
## 4        activite_cinema    n 826.0 1174.0  2000
## 5       activite_cuisine    %  44.0   56.0   100
## 6       activite_cuisine    n 881.0 1119.0  2000
## 7     activite_hard.rock    %   0.7   99.3   100
## 8     activite_hard.rock    n  14.0 1986.0  2000
## 9    activite_lecture.bd    %   2.4   97.7   100
## 10   activite_lecture.bd    n  47.0 1953.0  2000
## 11 activite_peche.chasse    %  11.2   88.8   100
## 12 activite_peche.chasse    n 224.0 1776.0  2000
## 13        activite_sport    %  36.1   63.8   100
## 14        activite_sport    n 723.0 1277.0  2000
```

### Pondérés

``` r
freqm(hdv2003, "activite_", poids = "poids")
##                   name calc       Oui        Non    Total
##        activite_bricol    %      40.9       59.1      100
##        activite_bricol    n 4527121.0  6544105.0 11071226
##        activite_cinema    %      44.5       55.5      100
##        activite_cinema    n 4925076.0  6146151.0 11071227
##       activite_cuisine    %      42.6       57.4      100
##       activite_cuisine    n 4714376.0  6356851.0 11071227
##     activite_hard.rock    %       0.8       99.2      100
##     activite_hard.rock    n   89264.0 10981963.0 11071227
##    activite_lecture.bd    %       2.5       97.5      100
##    activite_lecture.bd    n  274205.0 10797021.0 11071226
##  activite_peche.chasse    %      12.2       87.8      100
##  activite_peche.chasse    n 1354544.0  9716683.0 11071227
##         activite_sport    %      39.3       60.7      100
##         activite_sport    n 4356466.0  6714760.0 11071226
```

### Avec les pourcentages uniquement

``` r
freqm(hdv2003, 'activite_', poids="poids", calc="%")
##                   name  Oui  Non Total
##        activite_bricol 40.9 59.1   100
##        activite_cinema 44.5 55.5   100
##       activite_cuisine 42.6 57.4   100
##     activite_hard.rock  0.8 99.2   100
##    activite_lecture.bd  2.5 97.5   100
##  activite_peche.chasse 12.2 87.8   100
##         activite_sport 39.3 60.7   100
```

### En transposée

``` r
freqm(hdv2003, 'activite_', poids="poids", calc="all",transpose=T)
##  Modalités activite_bricol.. activite_bricol.n activite_cinema..
##        Oui              40.9         4527121.0              44.5
##        Non              59.1         6544105.0              55.5
##      Total               100          11071226               100
##  activite_cinema.n activite_cuisine.. activite_cuisine.n activite_hard.rock..
##          4925076.0               42.6          4714376.0                  0.8
##          6146151.0               57.4          6356851.0                 99.2
##           11071227                100           11071227                  100
##  activite_hard.rock.n activite_lecture.bd.. activite_lecture.bd.n
##               89264.0                   2.5              274205.0
##            10981963.0                  97.5            10797021.0
##              11071227                   100              11071226
##  activite_peche.chasse.. activite_peche.chasse.n activite_sport..
##                     12.2               1354544.0             39.3
##                     87.8               9716683.0             60.7
##                      100                11071227              100
##  activite_sport.n
##         4356466.0
##         6714760.0
##          11071226
```

### Si la variable n’est pas issue d’une question à choix multiple

``` r
freqm(hdv2003, 'sexe', poids="poids")
##  name calc     Homme     Femme    Total
##  sexe    %      46.5      53.5      100
##  sexe    n 5149382.0 5921844.0 11071226
```

### En transposée

``` r
freqm(hdv2003, 'sexe', poids="poids",  transpose=T)
##  Modalités    sexe..    sexe.n
##      Homme      46.5 5149382.0
##      Femme      53.5 5921844.0
##      Total       100  11071226
```

## freqp : Fréquences et pourcentages bruts et pondérés dans un même tableau

### Fréquences et pourcentages

``` r
freqp(hdv2003, "sexe", poids="poids")
##    sexe Brut.Freq Brut.. poids.Freq poids..
## 1 Homme       899     45    5149382    46.5
## 2 Femme      1101     55    5921844    53.5
## 3 Total      2000    100   11071226   100.0
```

### Sans les fréquences

``` r
freqp(hdv2003, "sexe", poids="poids", freq=F)
##    sexe Brut.. poids..
## 1 Homme     45    46.5
## 2 Femme     55    53.5
## 3 Total    100   100.0
```
