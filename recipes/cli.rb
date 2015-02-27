# If you set a directory, we will compile the CLI from there, and link
# to it. Probably only useful in development, or in very dire situations.
if node['delivery_build']['cli_dir']
  package "curl"

  remote_file "#{Chef::Config[:file_cache_path]}/rustup.sh" do
    source "https://static.rust-lang.org/rustup.sh"
  end

  # Note - you'll want to switch this to a stable rust in March,
  # or move it forward in the interim.
  execute "install rust and cargo" do
    command "bash #{Chef::Config[:file_cache_path]}/rustup.sh"
  end

  execute "cargo build --release" do
    cwd node['delivery_build']['cli_dir']
  end

  link "/usr/bin/delivery" do
    to File.join(node['delivery_build']['cli_dir'], 'target', 'release', 'delivery')
  end
end
