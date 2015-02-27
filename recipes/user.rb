user node['delivery_build']['build_user'] do
  home node['delivery_build']['root']
  comment "Delivery Build"
end
