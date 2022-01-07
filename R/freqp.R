#' Effectifs bruts, pondérés selon 1 ou + poids dans un même tableau
#'
#' @param table table de données
#' @param var variable
#' @param poids variable(s) contenant les poids
#' @param total Si F, n'ajoute pas le total
#' @param exclude vecteur : valeur(s) à exclure ; ex : c("-NC-",NA)
#' @param transpose Si T, présentation en transposée
#' @param brut Si F, ne présente pas les valeurs sans pondération
#' @param freq Si F, ne présente pas les valeurs de fréquence
#' @param pourc Si F, ne présente pas les valeurs de pourcentages
#' @param verbose  Si F, ne copie pas le tableau dans la console,
#'  quand le résultat est envoyé dans un objet par exemple
#'
#' @return Un tableau de fréquences et/ou pourcentage
#'
#' @encoding UTF-8
#'
#' @import dplyr
#' @import tibble
#' @import tidyr
#' @import questionr
#'
#' @export

freqp <- function(table,var,
                  total=T, exclude="",
                  transpose=F,
                  poids = NULL, verbose=T,
                  brut=T, freq=T, pourc=T){


 u <- freq(table[!table[,var]%in%exclude,var], total=total, valid=F) %>%
    data.frame() %>%
    rownames_to_column(var) %>%
    rename("Brut Freq"="n","Brut %"="X.")

  for (i in poids){
 t<-wtd.table(table[!table[,var]%in%exclude,var],
            weights = table[!table[,var]%in%exclude,i], useNA="ifany") %>%
    round(0) %>%
    data.frame() %>%
    mutate(`%`=round(Freq/sum(Freq)*100,1)) %>%
    bind_rows(summarise_all(., ~if(is.numeric(.)) sum(.) else "Total"))
 names(t)[1]<-var
 names(t)[2:3]<-paste(i, names(t)[2:3])
 u <- left_join(u,t,by=var)
  }
 if(brut==F){
   u <- u %>% select(-starts_with("Brut "))
 }
 if(freq==F){
   u <- u %>% select(-ends_with(" Freq"))
 }
 if(pourc==F){
   u <- u %>% select(-ends_with(" %"))
 }
  if(transpose==T){
    u <- u %>%
      t() %>% data.frame(stringsAsFactors = F) %>%
      rownames_to_column(".")
    names(u) <-u[1,]
    u <- u %>% slice(-(1))
  }

  if(verbose==F){
    return(u)
  }else{
    print(u, n=nrow(u), na.print="NA")
  }
}
