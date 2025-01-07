function awsprod --wraps='aws eks update-kubeconfig --region us-east-1 --name client-prod-us-east-1' --description 'alias awsprod=aws eks update-kubeconfig --region us-east-1 --name client-prod-us-east-1'
  aws eks update-kubeconfig --region us-east-1 --name client-prod-us-east-1 $argv
        
end
