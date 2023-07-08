#!/usr/bin/awk
match($0, section){
    matched = 1
    next
}

matched == 1 {
    if ( NF == 0 )
        exit
    # Skip comments
    else if( $1 ~ /\s*#.*/ )
        next
    print $0
}
