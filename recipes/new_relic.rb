on :load do
  if find_task("newrelic:notice_deployment")
    after :deploy,             "newrelic:notice_deployment"
    after "deploy:migrations", "newrelic:notice_deployment"
  end
end