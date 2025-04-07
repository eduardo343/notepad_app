require 'net/http'
require 'json'

def fetch_random_emoji(category)
    url = URI("https://emojihub.yurace.pro/api/random/category/#{category}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        data["htmlCode"]&.first || "📄"
    else
        "📄"
    end
rescue
    "📄"
end

puts "⏳ Cleaning database..."
Page.destroy_all
Notebook.destroy_all

puts "📘 Creating notebooks and pages..."

categories = [
    "smileys-and-people",
    "animals-and-nature",
    "food-and-drink",
    "travel-and-places",
    "activities"
]

3.times do |i|
    notebook = Notebook.create!(name: "Notebook #{i + 1}")

    5.times do |j|
        category = categories.sample
        emoji = fetch_random_emoji(category)

        notebook.pages.create!(
            title: "Page #{j + 1}",
            body: "Test content for page #{j + 1} in #{notebook.name}.",
            emoji_category: category,
            emoji: emoji
        )
        puts "✅ Page #{j + 1} in #{notebook.name} created with emoji #{emoji}"
    end
end

puts "🎉 Seed completed. You can now start your app with data!"
