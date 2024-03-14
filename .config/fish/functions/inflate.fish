function inflate --wraps='ruby -z zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"' --wraps='ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"' --description 'alias inflate ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"'
  ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)" $argv
        
end
