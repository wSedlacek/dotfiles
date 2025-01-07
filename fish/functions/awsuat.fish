function awsuat --wraps='aws eks update-kubeconfig --region us-east-1 --name client-uat-us-east-1' --description 'alias awsuat=aws eks update-kubeconfig --region us-east-1 --name client-uat-us-east-1'
  aws eks update-kubeconfig --region us-east-1 --name client-uat-us-east-1 $argv
        
end
