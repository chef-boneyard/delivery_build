directory File.expand_path(File.join(node['delivery_build']['root'], "..")) do
  mode '0755'
  recursive true
  action :create
end

user node['delivery_build']['build_user'] do
  home node['delivery_build']['root']
  comment "Delivery Build"
end
