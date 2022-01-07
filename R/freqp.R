# freqp : Présenter dans un même tableau les effectifs bruts,
# pondérés selon 1 ou + pondérations et %ages pondérés =========

# table = table de données
# var = variable
# exclude = Valeur à exclure = c("-NC-",NA), def = NULL
# poids = variable contenant les poids = "pond_pop", def = NULL
# brut = Présenter les valeurs sans pondération = F/T , def = T
# freq = Présenter les valeurs de fréquence = F/T , def = T
# pourc = Présenter les valeurs de pourcentages = F/T , def = T
# total = Ajout du total = F/T ; def = T
# transpose = Présentation en transposée = F/T , def = F
# verbose = Copie du tableau dans la console quand le résultat est envoyé dans un objet = F/T , def = T

#' @import dplyr
#' @import tibble
#' @import tidyr
#' @importFrom questionr freq
#' @importFrom questionr wtd.table
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
