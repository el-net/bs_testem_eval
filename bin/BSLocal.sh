#
#  starts the BSL server in BG
#  saves the PID in bsl.pid so we can kill it later
#
function start() {
    echo ""
    echo "starting BrowserStackLocal tunneling utility"
    echo ""
    echo ./bin/BrowserStackLocal -force $BROWSERSTACK_KEY  
    ./bin/BrowserStackLocal -force $BROWSERSTACK_KEY > bsl.log & 
    echo $! > bsl.pid
    
    FOUND="";
    ERROR="";
    WAITED=0;
    while [ "" == "$FOUND" ]; do
        if [ $WAITED -gt  30 ]; then
            echo ""
            echo ""
            echo "Could not start BrowseStackLocal bridge :( ";
            echo ""
            exit 1
        fi;
        echo "waiting for BS server to start... $WAITED";
        sleep 1;
        let WAITED=WAITED+1
        FOUND=$(grep "You can now access" bsl.log);
        ERROR=$(grep "Error:" bsl.log);
        
        if [ "" != "$ERROR" ]; then
            echo "";
            echo "$ERROR";
            echo "";
            exit 1;
        fi
    done;
    echo "";
    echo "BrowserStackLocal is started: ";
    echo "     $FOUND";
    echo "happy testing :)";
}


#
# kills the BSL server noted by bsl.pid
# cleans up bsl.pid
#
function stop() { 
    echo "stopping BrowserStackLocal tunnel";
    echo "Process Id: ";
    cat bsl.pid;
    
    kill $(cat bsl.pid);
    rm bsl.pid;
    
    echo "";
    echo "have fun";
}

case "$1" in
    start)
      start
      ;;
    stop)
      stop
      ;;
    *)
esac
