function nx
    command nx $argv
    set exit_code $status
    sleep 0.05
    return $exit_code
end
