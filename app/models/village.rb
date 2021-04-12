require_relative '../../lib/tools/scrapping_village'

class Village < ApplicationRecord
  has_one :town_hall

  validates :email,
    length: { maximum: 80, message: 'email length cannot be more than 80 characters' },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'email format is incorrect' }
  
  validates :name, presence: true, uniqueness: true, length: { in: 2..60 }
  validates :zip_code, presence: true, length: { is: 5 }
  validates :insee_code, presence: true, length: { in: 4..5 }

  # Scrapping

  def self.update_dep_list(dep_num)
    dep_num.length === 1 ? @num = "0" + dep_num : @num = dep_num

    url_dep = "https://www.annuaire-des-mairies.com/#{get_department_code(@num)}"

    errors_array = []

    errors_array.push(update_department_list("#{url_dep}.html"))

    nb_page = 2

    while check_if_page_exists("#{url_dep}-#{nb_page}.html")
      errors_array.push(update_department_list("#{url_dep}-#{nb_page}.html"))
      
      nb_page += 1

      if nb_page > 4
        break
      end
    end

    puts errors_array
  end

  def self.update_every_dep
    
  end

  def self.test_scrapping(dep_num, town_name)
    url = "https://www.annuaire-des-mairies.com/#{dep_num}/#{town_name.downcase}.html"

    if check_if_page_exists(url)
      insee = get_townhall_insee_code(url)
      zip = get_townhall_zip_code(url)
      this_mail = get_townhall_email(url).gsub(/ /, "")
    else
      return "url error" 
    end
    
    puts zip
    puts insee
    puts this_mail

    village = Village.new(name: town_name, email: "test@test.fr", zip_code: zip, insee_code: insee)

    puts village.save

    return [insee, zip, this_mail, village.save]
  end

  # Search

  scope :filter_by_name, lambda { |keyword|
    where('lower(name) LIKE ? ', "%#{keyword.downcase}%")
  }

  scope :filter_by_zip_code, lambda { |keyword|
    where('zip_code LIKE ? ', "#{keyword.downcase}%")
  }

  def self.search(params)
    villages = Village.all

    if params[:keyword]
      search_term = params[:keyword].split(' - ')

      search_term.each do |term|
        villages = villages.filter_by_name(term).or(villages.filter_by_zip_code(term))
      end
    end
    
    villages.first(10)
  end
end
