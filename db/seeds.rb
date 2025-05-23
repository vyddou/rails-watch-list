require 'open-uri'
require 'json'

puts "Nettoyage de la base..."
Bookmark.destroy_all  # Important à supprimer en premier à cause des dépendances
Movie.destroy_all
List.destroy_all

puts "Création de listes de test..."
lists = [
  "Action",
  "Comédies",
  "Science-Fiction",
  "Classiques",
  "Horreur"
]

lists.each do |list_name|
  List.create!(name: list_name)
end

puts "Récupération des films depuis TMDB..."
url = "https://tmdb.lewagon.com/movie/top_rated"
movies_created = 0

begin
  # Récupération des données
  response = URI.open(url, read_timeout: 10).read  # Timeout de 10s
  data = JSON.parse(response)

  # Traitement des films
  data['results'].first(20).each do |movie_data|
    puts "Importation de: #{movie_data['title']}"

    Movie.create!(
      title: movie_data['title'],
      overview: movie_data['overview'].presence || "Aucune description disponible",
      poster_url: movie_data['poster_path'].present? ?
                 "https://image.tmdb.org/t/p/original#{movie_data['poster_path']}" :
                 nil,
      rating: movie_data['vote_average'].to_f  # Une décimale
    )
    movies_created += 1

  rescue ActiveRecord::RecordInvalid => e
    puts "Erreur sur #{movie_data['title']}: #{e.message}"
  end

  puts "#{movies_created} films créés avec succès!"
  puts "#{Movie.count} films au total dans la base"

end
