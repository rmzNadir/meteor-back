namespace :create_data do
  desc "Create platforms for products"
  task create_platforms: :environment do
    Platform.find_or_create_by(name: 'PC')
    p "Se creo plataforma PC"
    Platform.find_or_create_by(name: 'Mac')
    p "Se creo plataforma Mac"
    Platform.find_or_create_by(name: 'Linux')
    p "Se creo plataforma Linux"
  end
  desc "Create languages for products"
  task create_languages: :environment do
    Language.find_or_create_by(name: 'Chino')
    p "Se creo el lenguaje Chino"
    Language.find_or_create_by(name: 'Español')
    p "Se creo el lenguaje Español"
    Language.find_or_create_by(name: 'Inglés')
    p "Se creo el lenguaje Inglés"
    Language.find_or_create_by(name: 'Portugués')
    p "Se creo el lenguaje Portugués"
    Language.find_or_create_by(name: 'Japonés')
    p "Se creo el lenguaje Japonés"
  end
end
