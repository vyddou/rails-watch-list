require 'open-uri'
require 'json'

puts "Nettoyage de la base..."
Movie.destroy_all
List.destroy_all

puts "Création de listes de test..."
List.create(name: "Action")
List.create(name: "Comédies")
List.create(name: "Science-Fiction")

puts "Récupération des films depuis TMDB..."
url = "https://tmdb.lewagon.com/movie/top_rated"

begin
  data = JSON.parse(URI.open(url).read)

  data['results'].first(20).each do |movie|
    puts "Traitement de: #{movie['title']}"

    Movie.find_or_create_by(title: movie['title']) do |m|
      m.overview = movie['overview'].presence || "Pas de description"
      m.poster_url = movie['poster_path'] ? "https://image.tmdb.org/t/p/original#{movie['poster_path']}" : nil
      m.rating = movie['vote_average'].to_f
    end
  end

  puts "#{Movie.count} films créés avec succès!"
rescue => e
  puts "Erreur: #{e.message}"

end
