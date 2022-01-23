#' Tris à plats multiples pondérable
#'
#' @param table table de données
#' @param racine_var racine des variables issues de quest. à choix multiple ; ex : "activite_"
#' @param calc choix du type de calcul : effectifs et/ou pourcentages = "n", "%", "all"
#' @param poids variable contenant les poids
#' @param total Si F, n'ajoute pas le total
#' @param exclude vecteur : Valeur(s) à exclure ; ex : c("-NC-",NA)
#' @param transpose Si T, présentation en transposée
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

freqm <- function(table,racine_var,
                  calc = "all",poids=NULL,
                  total=T, exclude=NULL,
                  transpose=F, verbose=T){
  # Préparation -----------
  if(calc == "all"){ calc <- c("n","%")}
  liste <- table %>% select(starts_with(racine_var)) %>% names()
  # Démarrer sur t vide :
  t <- NULL

  # A. pondéré --------
  if(is.null(poids)==F){
    for(i in liste){
      if(class(table[,i])=="factor"){
        vartable <- droplevels(table[!table[,i]%in%exclude,i])
      }else{
        vartable <- table[!table[,i]%in%exclude,i]
      }

      if(length(unique(vartable))<=1){
        t <- rbind(t,wtd.table(vartable,
                               weights = as.numeric(table[!table[,i]%in%exclude,poids]), useNA="ifany") %>%
                     round(0) %>%
                     data.frame() %>%
                     rownames_to_column("cols") %>%
                     rename("n"=".") %>%
                     mutate(n=as.integer(n)) %>%
                     mutate(`%`=round(n/sum(n)*100,1)) %>%
                     bind_rows(summarise_all(., ~if(is.numeric(.)) sum(.) else "Total")) %>%
                     mutate(name=i))
      }else{
        t <- rbind(t,
                   wtd.table(vartable,
                             weights = as.numeric(table[!table[,i]%in%exclude,poids]), useNA="ifany") %>%
                     round(0) %>%
                     data.frame() %>%
                     rename("n"="Freq","cols"="Var1") %>%
                     # rownames_to_column("cols") %>%
                     mutate(n=as.integer(n)) %>%
                     mutate(`%`=round(n/sum(n)*100,1)) %>%
                     bind_rows(summarise_all(., ~if(is.numeric(.)) sum(.) else "Total")) %>%
                     mutate(name=i))
      }
    }
  }else{
    # B. Non-pondéré ----------
    for(i in liste){
      if(class(table[,i])=="factor"){
        vartable <- droplevels(table[!table[,i]%in%exclude,i])
      }else{
        vartable <- table[!table[,i]%in%exclude,i]
      }
      t <- rbind(t,
                 freq(vartable, total=total) %>%
                   rownames_to_column("cols") %>%
                   mutate(name=i)
      )
    }
  }

  # Sortie ----------
  v <- t %>% select(cols, name, calc[1])
  v <- pivot_wider(v,
                   names_from = "cols",
                   values_from = calc[1],
                   values_fill = 0) %>%
    arrange(name)

  if(length(calc)>1){
    w <- t %>% select(cols, name, calc[2]) %>% mutate(calc=calc[2])
    w <- pivot_wider(w,
                     names_from = "cols",
                     values_from = calc[2],
                     values_fill = 0) %>%
      arrange(name)
    v <- rbind(v %>% mutate(calc=calc[1]),w) %>%
      select(name, calc, everything()) %>%
      arrange(name, calc)
  }

  if(total==T){
    v <- v %>% relocate(Total, .after = last_col())
  }else{
    v <- v %>% select(-'Total')
  }



  if(transpose==T){
    v <- v %>%
      t() %>% data.frame(stringsAsFactors = F) %>%
      rownames_to_column("--")

    if(length(calc)>1){
      paste <- paste(v[1,],v[2,])
      slice <- c(1,2)
    }else{
      paste <-v[1,]
      slice <- 1
    }

    names(v) <- paste
    v <- v %>%
      slice(-slice) %>%
      rename("Modalités"=1)
  }
  # if(verbose==F){
    return(data.frame(v))
  # }else{
  #   print(data.frame(v), n=nrow(v), na.print="NA", row.names=F)
  # }
}


