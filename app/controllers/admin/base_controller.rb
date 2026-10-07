# Common to every page of the admin space: only the admin account can open them.
class Admin::BaseController < ApplicationController
  before_action { authorize :admin, :access? } # app/policies/admin_policy.rb
end
