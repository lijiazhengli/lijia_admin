require 'mina/rails'
require 'mina/git'
require 'mina/puma'
require 'mina/rbenv'

set :user, 'root'          # Username in the server to SSH to.
set :application_name, 'lijia_admin'
set :domain, '78.141.216.178'
set :deploy_to, '/root/data/lijia_admin'
set :repository, 'git@github.com:lijiazhengli/lijia_admin.git'
set :branch, 'master'
# set :forward_agent, true     #使用本地的`SSH秘钥`去服务器执行`git pull`，这样`Git`上就不用设置`部署公钥`

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/master.key', 'config/puma.rb')

task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

task :setup do
  # command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  # command %[touch "#{fetch(:shared_path)}/config/master.key"]
  # command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  # comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    command %{#{fetch(:rails)} db:seed}
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        invoke :'puma:phased_restart'
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
