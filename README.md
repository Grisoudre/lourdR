
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

# Exemples

``` r
library(lourdR)
library(questionr)
library(dplyr)
```

## Données

A partir des données extraites de l’enquête “Histoire de vie”, 2003,
Insee, et fournies par le package {questionr} :

``` r
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
#> # A tibble: 14 × 5
#>    name                  calc     Non   Oui Total
#>    <chr>                 <chr>  <dbl> <dbl> <dbl>
#>  1 activite_bricol       %       57.4  42.6   100
#>  2 activite_bricol       n     1147   853    2000
#>  3 activite_cinema       %       58.7  41.3   100
#>  4 activite_cinema       n     1174   826    2000
#>  5 activite_cuisine      %       56    44     100
#>  6 activite_cuisine      n     1119   881    2000
#>  7 activite_hard.rock    %       99.3   0.7   100
#>  8 activite_hard.rock    n     1986    14    2000
#>  9 activite_lecture.bd   %       97.7   2.4   100
#> 10 activite_lecture.bd   n     1953    47    2000
#> 11 activite_peche.chasse %       88.8  11.2   100
#> 12 activite_peche.chasse n     1776   224    2000
#> 13 activite_sport        %       63.8  36.1   100
#> 14 activite_sport        n     1277   723    2000
```

### Pondérés

``` r
freqm(hdv2003, "activite_", poids = "poids")
#> # A tibble: 14 × 5
#>    name                  calc         Non       Oui    Total
#>    <chr>                 <chr>      <dbl>     <dbl>    <dbl>
#>  1 activite_bricol       %           59.1      40.9      100
#>  2 activite_bricol       n      6544105   4527121   11071226
#>  3 activite_cinema       %           55.5      44.5      100
#>  4 activite_cinema       n      6146151   4925076   11071227
#>  5 activite_cuisine      %           57.4      42.6      100
#>  6 activite_cuisine      n      6356851   4714376   11071227
#>  7 activite_hard.rock    %           99.2       0.8      100
#>  8 activite_hard.rock    n     10981963     89264   11071227
#>  9 activite_lecture.bd   %           97.5       2.5      100
#> 10 activite_lecture.bd   n     10797021    274205   11071226
#> 11 activite_peche.chasse %           87.8      12.2      100
#> 12 activite_peche.chasse n      9716683   1354544   11071227
#> 13 activite_sport        %           60.7      39.3      100
#> 14 activite_sport        n      6714760   4356466   11071226
```

### Avec les pourcentages uniquement

``` r
freqm(hdv2003, 'activite_', poids="poids", calc="%")
#> # A tibble: 7 × 4
#>   name                    Non   Oui Total
#>   <chr>                 <dbl> <dbl> <dbl>
#> 1 activite_bricol        59.1  40.9   100
#> 2 activite_cinema        55.5  44.5   100
#> 3 activite_cuisine       57.4  42.6   100
#> 4 activite_hard.rock     99.2   0.8   100
#> 5 activite_lecture.bd    97.5   2.5   100
#> 6 activite_peche.chasse  87.8  12.2   100
#> 7 activite_sport         60.7  39.3   100
```

### En transposée

``` r
freqm(hdv2003, 'activite_', poids="poids", calc="%",transpose=T)
#>   Modalités activite_bricol activite_cinema activite_cuisine activite_hard.rock
#> 1       Non            59.1            55.5             57.4               99.2
#> 2       Oui            40.9            44.5             42.6                0.8
#> 3     Total             100             100              100                100
#>   activite_lecture.bd activite_peche.chasse activite_sport
#> 1                97.5                  87.8           60.7
#> 2                 2.5                  12.2           39.3
#> 3                 100                   100            100
```

### Si la variable n’est pas issue d’une question à choix multiple

``` r
freqm(hdv2003, 'sexe', poids="poids")
#> # A tibble: 2 × 5
#>   name  calc      Homme     Femme    Total
#>   <chr> <chr>     <dbl>     <dbl>    <dbl>
#> 1 sexe  %          46.5      53.5      100
#> 2 sexe  n     5149382   5921844   11071226
```

### En transposée

``` r
freqm(hdv2003, 'sexe', poids="poids",  transpose=T)
#>   Modalités    sexe %    sexe n
#> 1     Homme      46.5 5149382.0
#> 2     Femme      53.5 5921844.0
#> 3     Total       100  11071226
```

## freqp : Fréquences et pourcentages bruts et pondérés dans un même tableau

### Fréquences et pourcentages

``` r
freqp(hdv2003, "sexe", poids="poids")
#>    sexe Brut Freq Brut % poids Freq poids %
#> 1 Homme       899     45    5149382    46.5
#> 2 Femme      1101     55    5921844    53.5
#> 3 Total      2000    100   11071226   100.0
```

### Sans les fréquences

``` r
freqp(hdv2003, "sexe", poids="poids", freq=F)
#>    sexe Brut % poids %
#> 1 Homme     45    46.5
#> 2 Femme     55    53.5
#> 3 Total    100   100.0
```
