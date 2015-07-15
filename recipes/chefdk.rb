#
# Copyright 2015 Chef Software, Inc.
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

package 'chefdk' do
  action :upgrade
end

# For now, we need to add a gemrc file to get Chef to install gems
# into ChefDKs gem directory (as opposed to the home directory).
#
# Please see https://github.com/opscode/chef-dk/issues/198 and
# https://gist.github.com/danielsdeleo/b13a7be090905bb97f2d for more
# (The '--no-user-install' bit is key for us currently)
#
# We're inlining the  file content as opposed to using a cookbook_file
# resource here because there were some issues resolving the file; we
# think it has to do with the fact that this cookbook is its own build
# cookbook, and the recursion and inception that results. We can come
# back later and tweak that if we want.
file '/root/.gemrc' do
  owner 'root'
  mode '0644'
  content <<-EOF
---
:benchmark: false
:verbose: true
:update_sources: true
gem: --no-rdoc --no-ri
install: --no-user-install
:sources:
- http://rubygems.org/
- http://gems.github.com/
:backtrace: true
:bulk_threshold: 1000
EOF
  action :create
end

ENV['PATH'] = "/opt/chefdk/bin:/opt/chefdk/embedded/bin:#{ENV['PATH']}"
