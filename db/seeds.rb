# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

puts "Nettoyage de la base..."
Movie.destroy_all # Attention: efface tous les films existants

puts "Récupération des films depuis TMDB..."
url = "https://tmdb.lewagon.com/movie/top_rated"

begin
  data = JSON.parse(URI.open(url).read)

  data['results'].first(20).each do |movie| # Limite à 20 films
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
  # Seed de secours ici...
end
