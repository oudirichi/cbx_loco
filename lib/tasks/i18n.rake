namespace :i18n do
  require 'cbx_loco'

  desc "Extract i18n assets, and upload them to the online service"
  task :extract do
    command { extract: true }
    CbxLoco.run command
  end

  desc "Import compiled i18n assets from the online service"
  task :import do
    command { import: true }
    CbxLoco.run command
  end
end
