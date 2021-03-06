github_list <- function(username){
  myurl <- paste("https://api.github.com/users", username, "repos", sep="/");
  mysecret <- gitsecret();
  if(!is.null(mysecret)){
    myurl <- paste(myurl, "?client_id=", mysecret$client_id, "&client_secret=", mysecret$client_secret, sep="");
  }
  
  #temporary fix for Mavericks CF
  if(grepl("darwin", R.Version()$platform)){
    out <-  eval_psock(httr::GET(myurl, httr::add_headers("User-Agent" = "OpenCPU")), list(myurl=myurl));
  } else {
    out <- GET(myurl, add_headers("User-Agent" = "OpenCPU"));
  }
  
  stop_for_status(out)
  response <- fromJSON(rawToChar(out$content), simplifyWithNames=FALSE);
  
  #proxy limit headers
  if(length(out$headers[["X-RateLimit-Limit"]])){
    res$setheader("X-RateLimit-Limit", out$headers[["X-RateLimit-Limit"]])
  }
  if(length(out$headers[["X-RateLimit-Limit"]])){
    res$setheader("X-RateLimit-Remaining", out$headers[["X-RateLimit-Remaining"]])
  }    
  
  #cache the response
  res$setcache("gitapi"); 
  
  unlist(lapply(response, function(x) {x$name}));                  
}
