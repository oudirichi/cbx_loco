class CbxLoco::Railtie < ::Rails::Railtie

  railtie_name :cbx_loco

  rake_tasks do
    load 'tasks/i18n.rake'
  end
end
