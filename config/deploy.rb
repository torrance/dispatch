set :application, "dispatch"

set :use_sudo, false
set :user, 'indymedia'
set :deploy_to, "/var/www/www.indymedia.org.nz"

set :repository,  "https://github.com/torrance/dispatch.git"
set :branch, 'master'
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "flax.indymedia.org.nz"                          # Your HTTP server, Apache/etc
role :app, "flax.indymedia.org.nz"
role :db, "flax.indymedia.org.nz"


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
set :rake,  "/var/lib/gems/1.9.1/bin/rake"
# This secret token is only temporarily used during deployment. Otherwise it is set by environment variable.
set :secret_token, 'd12a472fad0423d80856cb03ee5b4999cde3a6e0d48bd247984e3d0fde1b51f1c0269a024555371d3d9fac89ce805c3700ae848f81f703ccad3b122ea4923608'
after "deploy:update_code" do
  run "cd #{release_path}; RAILS_ENV=production RAILS_SECRET_TOKEN=#{secret_token} #{rake} assets:precompile; RAILS_ENV=production RAILS_SECRET_TOKEN=#{secret_token} #{rake} db:migrate"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end