#' Effectifs bruts, pondérés selon 1 ou + poids dans un même tableau
#'
#' @param table table de données
#' @param var variable
#' @param poids variable(s) contenant les poids
#' @param total Si F, n'ajoute pas le total
#' @param exclude vecteur : valeur(s) à exclure ; ex : c("-NC-",NA)
#' @param transpose Si T, présentation en transposée
#' @param brut Si F, ne présente pas les valeurs sans pondération
#' @param n Si F, ne présente pas les valeurs d'effectifs
#' @param pourc Si F, ne présente pas les valeurs de pourcentages
#'
#' @return Un tableau d'effectifs et/ou pourcentages
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
                  total=T, exclude=NULL,
                  transpose=F,
                  poids = NULL, verbose=T,
                  brut=T, n=T, pourc=T){



  if(class(table[,var])=="factor"){
    tablevar <- droplevels(table[!table[,var]%in%exclude,var])}else{
      tablevar <- table[!table[,var]%in%exclude,var]
    }


  u <- freq(tablevar, total=total, valid=F) %>%
    data.frame() %>%
    rownames_to_column(var) %>%
    rename("Brut n"="n","Brut pourc"="X.")

  for (i in poids){
    t<-wtd.table(tablevar,
                 weights = as.numeric(table[!table[,var]%in%exclude,i]), useNA="ifany") %>%
      round(0) %>%
      data.frame() %>%
      mutate(`pourc`=round(Freq/sum(Freq)*100,1)) %>%
      rename("n"="Freq") %>%
      bind_rows(summarise_all(., ~if(is.numeric(.)) sum(.) else "Total"))
    names(t)[1]<-var
    names(t)[2:3]<-paste(i, names(t)[2:3])
    u <- left_join(u,t,by=var)
  }
  if(brut==F){
    u <- u %>% select(-starts_with("Brut "))
  }
  if(n==F){
    u <- u %>% select(-ends_with(" n"))
  }
  if(pourc==F){
    u <- u %>% select(-ends_with(" pourc"))
  }
  if(transpose==T){
    u <- u %>%
      t() %>% data.frame(stringsAsFactors = F) %>%
      rownames_to_column(".")
    names(u) <-u[1,]
    u <- u %>% slice(-(1))
  }

  # if(verbose==F){
    return(data.frame(u))
  # }else{
  #   print(data.frame(u), n=nrow(u), na.print="NA")
  # }
}
