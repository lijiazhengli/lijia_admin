require 'mina/rails'
require 'mina/git'
require 'mina/puma'
require 'mina/rbenv'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'lijia_admin'
set :domain, '78.141.216.178'
set :deploy_to, '/root/data/lijia_admin'
set :repository, 'git@github.com:lijiazhengli/lijia_admin.git'
set :branch, 'master'
# set :forward_agent, true     #使用本地的`SSH秘钥`去服务器执行`git pull`，这样`Git`上就不用设置`部署公钥`

# Optional settings:
set :user, 'root'          # Username in the server to SSH to.

set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/master.key')

task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
