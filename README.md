```
git clone git@github.com:unepwcmc/pp-live-report.git # clone repository
cd pp-live-report
rbenv install $(cat .ruby-version)
gem install bundler -v 2.0.1 # bundle with version of bundler listed in Gemfile.lock
bundle _2.0.1_ install
nvm use # use Node version specified in .nvmrc
npm install -g yarn # install yarn if missing
yarn install # install frontend dependencies
cp .env.example .env # contents available from LastPass:"pp-live-report Development Environment"
rails s # start web server
./bin/webpack-dev-server # run in a separate process
```