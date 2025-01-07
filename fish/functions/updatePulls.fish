function updatePulls
  if [ (count $argv) -eq 2 ]; # No arguments
      set currentBase $argv[1]
      set newBase $argv[2]
      gh pr list --base "$currentBase" | egrep -o '^\d+' | xargs -n1 gh pr edit --base "$newBase"
  else # At least one argument
      echo "Usage: updatePulls currentBase newBase"
      return
  end
end
