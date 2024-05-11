require 'json'

class Inventory
    attr_reader :books

    def initialize
        @books = load_books
    end
    
    def load_books
        if File.exist?('Books.json')
            File.open('Books.json', 'r') do |file|
                JSON.parse(file.read) 
            end
        else
          []
        end
    end

    # Function to allow user to write in the JSON file to add a new book
    def save_books
        File.write('Books.json', JSON.pretty_generate(@books))
    end

    # Function to allow user to read the JSON file containing all books available in the inventory
    def list_books
        @books.each do |book|
            puts "Title: #{book['title']}, Author: #{book['author']}, ISBN: #{book['isbn']}"
        end
    end

    def add_book(title = nil, author = nil, isbn = nil)
        if title && author && isbn
            existing_book = @books.find { |book| book['isbn'] == isbn }
            if existing_book
                existing_book['title'] = title
                existing_book['author'] = author
                existing_book['isbn'] = isbn
            else
                # To append the added book to the array exists
                @books << { 'title' => title, 'author' => author, 'isbn' => isbn }
            end
            save_books
            puts "Book added successfully"
        else
            puts "You should enter 3 arguments"
        end      
    end


    # Function to remove a book 
    def remove_book(isbn)
        index = @books.find_index { |book| book['isbn'] == isbn }
        if index
        @books.delete_at(index)
        save_books
        puts "book with isbn #{isbn} removed successfully"
        else
            puts "book with isbn #{isbn} is not found"
        end
    end

    # Function to sort books by isbn
    def sort_books_by_isbn
        @books.sort_by! { |book| book['isbn'].to_i }
        save_books
        puts "Books sorted by isbn"
    end

    # Function to search by title
    def search_books_by_title(title)
        puts "Searching for books by title: #{title}"
        found_books = @books.select { |book| book['title'].strip.downcase.include?(title.strip.downcase)} 
        puts "Found #{found_books.length} books"
        found_books.each do |book|
            puts "Title: #{book['title']}, Author: #{book['author']}, ISBN: #{book['isbn']}"
        end
    end

    # Function to search by author
    def search_books_by_author(author)
        puts "Searching for books by author: #{author}"
        found_books = @books.select { |book| book['author'].strip.downcase.include?(author.strip.downcase)} 
        puts "Found #{found_books.length} books"
        found_books.each do |book|
            puts "Title: #{book['title']}, Author: #{book['author']}, ISBN: #{book['isbn']}"
        end
    end

    # Function to search by isbn
    def search_books_by_isbn(isbn)
        found_books = @books.select { |book| book['isbn'].strip.downcase == isbn.strip.downcase } 
        found_books.each do |book|
            puts "Title: #{book['title']}, Author: #{book['author']}, ISBN: #{book['isbn']}"
        end
    end



end


    inventory = Inventory.new
    loop do
        puts "1. List Books"
        puts "2. Add Book"
        puts "3. Remove Book"
        puts "4. Sort by isbn"
        puts "5. Search Books by Title"
        puts "6. Search Books by Author"
        puts "7. Search Books by ISBN"
        puts "8. Exit"
        print "Enter your choice: "
        choice = gets.to_i

        case choice
        when 1
            inventory.list_books
        when 2
            print "Enter Title: "
            title = gets
            print "Enter Author: "
            author = gets
            print "Enter ISBN: "
            isbn = gets
            inventory.add_book(title, author, isbn)
        when 3
            print "Enter isbn of the book you want to remove: "
            isbn = gets
            inventory.remove_book(isbn)  
        when 4
            inventory.sort_books_by_isbn()  
            inventory.list_books  
        when 5
            print "Enter title: "
            title = gets
            inventory.search_books_by_title(title)
        when 6
            print "Enter author: "
            author = gets
            inventory.search_books_by_author(author)  
        when 7
            print "Enter isbn: "
            isbn = gets
            inventory.search_books_by_isbn(isbn)                
        when 8
            print "Exiting program..."
            break
        else
            puts "Invalid Choice, Please try again!"
        end
        print "Do you want to continue? (1.Y / 2.N): "
        continue_choice = gets.to_i
        if continue_choice == 2
            break
        end
    end