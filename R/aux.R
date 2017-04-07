tidy_rediff <- function(df){
    df <- df[order(df$Rdt), ]
    rownames(df) <- NULL
    ndx1 <- seq(from=1, to=nrow(df)-1)
    ndx2 <- seq(from=2, to=nrow(df))
    df$diff_secs <- NA
    df$diff_secs[ndx1] <- abs(difftime(df$Rdt[ndx1], df$Rdt[ndx2], units = 'secs'))
    return(df)
}

tidy <- function(dat){
    ## Time
    unique(dat$Time_NZST) # Fuck
    indx <- str_detect(dat$Time_NZST, "M")
    unique(dat$Time_NZST[indx])
    dat$Time_NZST[indx] <- format(strptime(dat$Time_NZST[indx], "%I:%M:%S %p"), "%H:%M")
    unique(dat$Time_NZST)
    dat$Time_NZST <- str_pad(dat$Time_NZST, width = 5, pad = '0')
    unique(dat$Time_NZST)
    length(unique(dat$Time_NZST))
    
    ## Date
    unique(dat$Year)
    unique(dat$Month)
    dat$Month <- str_pad(dat$Month, width = 2, pad = '0')
    unique(dat$Month)
    unique(dat$Day)
    dat$Day <- str_pad(dat$Day, width = 2, pad = '0')
    unique(dat$Day)
    
    # Combine
    dat$Sdt <-  with(dat, paste0(Year, '-', Month, '-', Day, "T", Time_NZST))
    dat$Rdt <- as.POSIXct(strptime(dat$Sdt, "%Y-%m-%dT%H:%M", tz="UTC"))
    
    # Trim
    keep_cols <- c("Sdt", "Rdt", "PAR")
    dat_trim <- dat[, keep_cols]
    dat_trim <- tidy_rediff(dat_trim)
    
    # Find bits > 300 seconds
    ndx <- which(dat_trim$diff_secs>300)
    ndx <- sort(c(ndx, ndx+1))
    dat_trim[ndx, ]
    
    ## Insert NAs
    all_dts <- seq(from=min(dat_trim$Rdt), to=max(dat_trim$Rdt), by = 300)
    indx <- all_dts %in% dat_trim$Rdt
    missing <- data.frame(Rdt = all_dts[!indx])
    head(missing)
    dat_trim <- data.frame(bind_rows(dat_trim, missing))
    dat_trim <- tidy_rediff(dat_trim)
    table(dat_trim$diff_secs) # Woo hoo!
    indx <- is.na(dat_trim$Sdt)
    dat_trim[indx, 'Sdt'] <- format(dat_trim[indx, 'Rdt'], "%Y-%m-%dT%H:%M")
    
    return(dat_trim)
}

