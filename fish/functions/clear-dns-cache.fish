function clear-dns-cache --wraps='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder' --description 'alias clear-dns-cache sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder $argv
        
end
