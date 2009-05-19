on :load do
  if find_task("newrelic:notice_deployment")
    after_any_deployment "newrelic:notice_deployment"
  end
end