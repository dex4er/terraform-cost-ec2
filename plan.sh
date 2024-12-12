terraform plan -out tfplan.binary && terraform show -json tfplan.binary > plan.json && infracost breakdown --path plan.json && infracost breakdown --path plan.json --format html > plan.html
