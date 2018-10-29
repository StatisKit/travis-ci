set -ve

if [[ ! "$TRAVIS_WAIT" = "" ]]; then
  travis_wait() {
    local cmd="$@"
    local log_file=travis_wait_$$.log

    $cmd 2>&1 >$log_file &
    local cmd_pid=$!

    travis_jigger $! $cmd &
    local jigger_pid=$!
    local result

    { wait $cmd_pid 2>/dev/null; result=$?; ps -p$jigger_pid 2>&1>/dev/null && kill $jigger_pid; } || exit 1
    exit $result
  }

  if [[ "$TRAVIS_WAIT" = "true" ]]; then
    export TRAVIS_WAIT=20
  fi
  
  travis_jigger() {
    echo $TRAVIS_WAIT
    local timeout=$TRAVIS_WAIT # in minutes
    local count=0

    local cmd_pid=$1
    shift

    while [ $count -lt $timeout ]; do
      count=$(($count + 1))
      echo -e "\033[0mStill running ($count of $timeout): $@"
      sleep 60
    done

    echo -e "\n\033[31;1mTimeout reached. Terminating $@\033[0m\n"
    kill -9 $cmd_pid
  }

  export TRAVIS_WAIT=travis_wait
fi

set +ve
