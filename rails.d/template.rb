# Inlining a bunch of file directives is a pain in the ass.  Just use an
# existing directory instead.
def directory(path, log_action = true)
  path = File.expand_path(path)
  log 'directory', path if log_action
  in_root do
    everything_including_dotfiles = "{.[!.]*,*}"
    sources = Dir.glob(File.join(path, everything_including_dotfiles))
    FileUtils.cp_r(sources, ".")
  end
end

def app_name
  name = nil
  in_root { name = File.basename(FileUtils.pwd) }
  name
end

# Rails should utilize better yaml conventions
def rewrite_database_yml
  gsub_file "config/database.yml.example", "APP_NAME", app_name
  run "cp config/database.yml.example config/database.yml"
end

############################################################

paperclip    = yes?("Add the paperclip gem?")
clearance    = yes?("Add the clearance gem?")
twitter_auth = yes?("Add the twitter-auth gem?") unless clearance
bluecloth    = yes?("Add the bluecloth gem?")
aasm         = yes?("Add the aasm gem?")
delayed_job  = yes?("Add the delayed_job gem?")

%w(index.html dispatch.* javascripts/*.js images/rails.png favicon.ico).each do |public_file|
  run "rm public/#{public_file}"
end

capify!

directory "~/.rails.d/template"

rewrite_database_yml

run "mkdir -p app/javascripts/vendor"
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > app/javascripts/vendor/jquery.js"

gem "bluecloth",                        :version => "2.0.5" if bluecloth
gem "haml",                             :version => "2.2.8",  :source  => "http://gemcutter.org"
gem "giraffesoft-enum_field",           :version => "0.2.0",  :lib => "enum_field",       :source  => "http://gems.github.com"
gem "justinfrench-formtastic",          :version => "0.2.4",  :lib => "formtastic",       :source  => "http://gems.github.com"
gem "thoughtbot-hoptoad_notifier",      :version => "1.1",    :lib => "hoptoad_notifier", :source  => "http://gems.github.com"
gem "thoughtbot-pacecar",               :version => "1.1.6",  :lib => "pacecar",          :source  => "http://gems.github.com"
gem "thoughtbot-paperclip",             :version => "2.3.1",  :lib => "paperclip",        :source  => "http://gems.github.com" if paperclip
gem "thoughtbot-clearance",             :version => "0.8.1",  :lib => "clearance",        :source  => "http://gems.github.com" if clearance
gem "aasm",                             :version => "2.1.1",  :source  => "http://gemcutter.org" if aasm
gem "chriseppstein-compass",            :version => "0.8.17", :source  => "http://gemcutter.org"
gem "chriseppstein-compass-colors",     :version => "0.2.0",  :lib => "compass-colors",   :source  => "http://gems.github.com"
gem "chriseppstein-compass-960-plugin", :version => "0.9.10", :lib => "ninesixty",        :source  => "http://gems.github.com"
gem "ghazel-daemons",                   :version => "1.0.11", :lib => "daemons",          :source  => "http://gems.github.com" if delayed_job
gem "delayed_job",                      :version => "1.8.2",  :source  => "http://gemcutter.org" if delayed_job
gem "twitter-auth",                     :version => "0.1.22", :source  => "http://gemcutter.org" if twitter_auth

# gem "mocha",                   :env => :test # rails auto requires this
gem "redgreen",                :env => :test, :version => "1.2.2"
gem "fakeweb",                 :env => :test, :version => "1.2.6"
gem "thoughtbot-shoulda",      :env => :test, :version => "2.10.2", :lib => "shoulda",      :source  => "http://gems.github.com"
gem "thoughtbot-factory_girl", :env => :test, :version => "1.2.2",  :lib => "factory_girl", :source  => "http://gems.github.com"

plugin "strip_attributes",       :git => "git://github.com/rmm5t/strip_attributes.git"
plugin "dancing_with_sprockets", :git => "git://github.com/coderifous/dancing_with_sprockets.git"
plugin "custom_err_message",     :git => "git://github.com/gumayunov/custom-err-msg.git"
plugin "lovely_layouts",         :git => "git://github.com/justinfrench/lovely-layouts.git"

# Compass config
run "compass --rails --sass-dir app/stylesheets --css-dir public/stylesheets -r ninesixty -r compass-colors -f 960 ."
run "compass --rails -f colors -p split_complement ."

if paperclip
  paperclip_initializer = <<-CODE
Paperclip::Attachment.default_options[:url]         = "/system/:class/:attachment/:id_partition/:style/:filename"
Paperclip::Attachment.default_options[:default_url] = "/images/:class/:attachment/:style/missing.png"

# WARN: Hard-coded MacPorts ImageMagick for development
Paperclip.options[:command_path] = "/opt/local/bin" if Rails.env.development?
CODE

  initializer 'paperclip.rb', paperclip_initializer
end

if clearance
  environment "#For email\n  DO_NOT_REPLY = \"donotreply@#{app_name}.com\"\n"
  environment "\n#For email\nHOST = \"#{app_name}.local\"", :env => :test
  environment "\n#For email\nHOST = \"#{app_name}.local\"", :env => :development
  environment "\n#For email\nHOST = \"#{app_name}.com\"",   :env => :production
end

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
