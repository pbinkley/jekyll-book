Jekyll::Hooks.register :site, :pre_render do |site|
  # code to call before Jekyll renders the site
  system("_scripts/render.sh")
  # reload _data directory to pick up changes to downloads.yml
  site.data = Jekyll::DataReader.new(site).read(site.config['data_dir'])
end
