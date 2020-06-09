#
# Copyright:: 2015 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node['delivery_build']['trusted_certs'].each do |name, cert|
  # Append trusted_cert to ChefDK cacert.pem
  trusted_cert "#{name}-chefdk" do
    path cert
  end

  # Append trusted_cert to Push Jobs Client cacert.pem
  trusted_cert "#{name}-push-jobs" do
    path cert
    cacert_pem lazy { DeliveryBuild::PathHelper.omnibus_push_jobs_cacert_pem }
    # Push Jobs Client for Windows does not curerntly ship with a cacert.pem
    not_if { windows? }
  end
end
