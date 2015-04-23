packagecloud_repo node['delivery_build']['repo_name'] do
  type value_for_platform_family(debian: 'deb', rhel: 'rpm')
end
