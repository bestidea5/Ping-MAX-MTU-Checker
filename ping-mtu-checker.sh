#!/bin/bash

# Usage: ping-mtu-checker.sh $target_host

if ! which ping > /dev/null 2>&1; then
    echo "ping is not installed"
    exit 1
fi

target_host=$1
size=1272

if ! ping -c1 $target_host >&/dev/null; then
   echo "$target_host does not respond to ping"
   exit 1
fi

if ping -s $size -M do -c1 $target_host >&/dev/null; then
   # GNU ping
   nofragment='-M do'
else
   # BSD ping
   nofragment='-D'
fi

while ping -s $size $nofragment -c1 $target_host >&/dev/null; do
    ((size+=4));
done

echo "Max MTU size to $target_host: $((size-4+28))"
